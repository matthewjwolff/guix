(define-module (wolff services)
  #:use-module (gnu packages base)
  #:use-module (gnu packages docker)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services mcron)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:use-module (rosenthal packages web)
  #:use-module (wolff packages)
  #:export (acme.sh-service-type
            acme.sh-service-configuration
            anubis-service-type
            docker-compose-service-configuration
            docker-compose-service-type
            git-repo-service-type))


(define (anubis-activation config)
  #~(unless (file-exists? "/run/anubis")
      (mkdir "/run/anubis")
      (chown "/run/anubis" (passwd:uid (getpw "nginx")) (passwd:gid (getpw "nginx")))))

(define (anubis-service config)
  (list (shepherd-service (provision '(anubis))
                          (requirement '(user-processes networking))
                          (auto-start? #t)
                          (respawn? #t)
                          (start #~(make-forkexec-constructor (list (string-append #$anubis-anti-crawler "/bin/anubis")
                                                                    "-bind" "/run/anubis/instance.sock"
                                                                    "-bind-network" "unix"
                                                                    "-target" "unix:///var/run/nginx/nginx.sock"
                                                                    )
                                                              ;; instance socket needs to be readable by nginx
                                                              #:user "nginx" #:group "nginx"))
                          (stop #~(make-kill-destructor)))))

(define anubis-service-type
  (service-type
   (name 'anubis)
   (description "Anubis anti-crawler proxy")
   (default-value '())
   (extensions (list (service-extension shepherd-root-service-type anubis-service)
                     (service-extension activation-service-type anubis-activation)))))

(define-record-type* <acme.sh-service-configuration>
  acme.sh-service-configuration make-acme.sh-service-configuration
  acme.sh-service-configuration?
  (certs acme.sh-configuration-certs)
  (dns-provider acme.sh-configuration-dns-provider))

(define (acme.sh-activation config)
  #~(begin
      (mkdir-p "/etc/acme.sh")
      (open-file "/etc/acme.sh/account.conf" "w")
      ;; put things in account.conf
      (use-modules (ice-9 ftw)) ;; scandir
      (define dir-contents (scandir "/etc/acme.sh"))
      (define (issue-cert cert-name)
        (use-modules (srfi srfi-1)) ;; any
        ;; cut doesn't work with gexp (unbound variable <>)
        (unless (any (lambda (obj) (string-prefix? cert-name obj)) dir-contents)
          ;; add --force to allow use with sudo
          (system* (string-append #$acme.sh "/bin/acme.sh") "--config-home" "/etc/acme.sh" "--issue" "-d" cert-name "--dns" #$(acme.sh-configuration-dns-provider config) "--server" "letsencrypt" "--force")))
      (map issue-cert (list #$@(acme.sh-configuration-certs config)))))


(define (acme.sh-cron config)
  ;; TODO for now, hack together a job with coreutils in PATH
  ;; because copy-build-system doesn't send a cross compiled coreutils (implicit input from gnu-build-system)
  ;; can't use (system) because guile doesn't have a sh set up i guess
  ;; note: these ungexps pull the right dependencies (cross compiled grep, coreutils)
  ;; remember, only hand-writing the environment because copy-build-system pulls native dependencies instead of cross-compiled dependencies
      ;; it really should be in the package, because these *are* the dependencies of the script
  (list #~(job "30 1 * * *"
               (lambda ()
                 (let* ((progname (string-append #$acme.sh "/bin/acme.sh"))
                        (coreutils-dir (string-append #$coreutils "/bin"))
                        (grep-dir (string-append #$grep "/bin"))
                        (openssl-dir (string-append #$openssl "/bin"))
                        (environment (list (string-append "PATH=/bin" ;; for /bin/sh
                                                          ":" coreutils-dir ;; various commands
                                                          ":" grep-dir ;; grep
                                                          ":" openssl-dir)))) ;; cert stuff
                   (waitpid (spawn progname (list progname "--config-home" "/etc/acme.sh" "--cron") #:environment environment))))
               "acme.sh renewal check")))

(define acme.sh-service-type
  (service-type
   (name 'acme.sh-service)
   (description "Manage certificates using acme.sh")
   (extensions (list
                (service-extension activation-service-type acme.sh-activation)
                (service-extension mcron-service-type acme.sh-cron)
                ;; TODO make sure acme.sh is in the system profile
                ))))

;; see guix/records.scm for info about define-record-type*
;; summary: normal is (define-record-type <type> (constructor fieldname...) predicate (fieldname accessor [modifier])...)
;; augmented is (define-record-type* <type> syntactic-constructor (normal-constructor fieldname...) etc)
(define-record-type* <docker-compose-service-configuration>
  docker-compose-service-configuration make-docker-compose-service-configuration
  docker-compose-service?
  (name docker-compose-service-name)
  (compose-file docker-compose-compose-file)
  (auto-start? docker-compose-auto-start? (default #f))
  (respawn? docker-compose-respawn? (default #f))
  (user docker-compose-service-user))

(define (docker-compose-service config)
  (list (shepherd-service (provision `(,(docker-compose-service-name config))) ;; provision defines what this services provices, and is what is passed to herd start <provision>
                          (requirement '(user-processes networking dockerd))
                          (auto-start? (docker-compose-auto-start? config))
                          (respawn? (docker-compose-respawn? config))
                          (start #~(make-forkexec-constructor (list (string-append #$docker-compose "/bin/docker-compose")
                                                                    "-f" #$(docker-compose-compose-file config)
                                                                    "-p" #$(symbol->string (docker-compose-service-name config))
                                                                    "up")))
                          (stop #~(make-kill-destructor)))))

;; TODO may have to have an activation that docker-compose pulls
;; otherwise might retain link to stale runc
;; https://lists.nongnu.org/archive/html/bug-guix/2021-04/msg00147.html
(define docker-compose-service-type
  (service-type
   (name 'docker-compose-service)
   (description "A docker-compose service")
   (extensions (list (service-extension shepherd-root-service-type docker-compose-service))))) ;; no default value
;; note: extending profile-service-type can add packages and configuration files to the system profile (/run/current-system/profile/bin, /etc, etc)

;; it resolves to a list because that's how guix does service "extensions"
;; config is the parameter (allowing end-users to pass in values to configure their instance of the service)
;; here, nothing to configure
;; it should also handle destroying and recreating the container on upgrade
;; see https://lists.gnu.org/archive/html/bug-guix/2021-04/msg00147.html

#|
(define (matrix-service config)
(list (shepherd-service (provision '(matrix))
(requirement '(user-processes networking))
(auto-start? #t)
(respawn? #t)
;; TODO this is probably not right, python is in a different package than matrix. how does guix do this?
;; probably setting PYTHONPATH to something based on #$synapse, i think that's what some existing services do
;; note: guix actually manages user profiles such that if you install python, all python packages are linked in .guix-profile, and python knows enough to source through this link
;; note: none of the python packages have a dependency on python. i guess that's like saying "use whatever python you can find"
;; TODO this might be right, but synapse is out of date
(start #~(make-forkexec-constructor (list (string-append #$python "/bin/python3") "-m" "synapse.app.homeserver" "--config-path=/home/mjw/configuration/homeserver.yaml")  #:user "mjw" #:group "users" #:directory "/home/mjw/matrix" #:environment-variables (cons (string-append "PYTHONPATH=" #$synapse) default-environment-variables) ))
(stop #~(make-kill-destructor #:grace-period 180))))) ; arch stops via synctl stop path/to/homeserver.yaml
|#

;; for now, config is a simple list of (name . url)

(define (git-repo-activation config)
  "Make directories and clone repos as necessary"
    #~(begin
       (define (create-repository config-el)
         (let ((remote-url (cdr config-el))
               (local-path (string-append "/srv/git/" (car config-el))))
           (if (access? local-path F_OK)
               (display (string-append "Skipping repo clone, " local-path " already exists.\n"))
               (system* (string-append #$git "/bin/git") "clone" (cdr config-el) (string-append "/srv/git/" (car config-el))))))
       (mkdir-p "/srv/git")
       (map create-repository '(#$@config))))

(define (git-repo-pull config)
  "Periodically run git pull in all repos"
  (define (repository->job repository)
    ;; source /etc/profile to get environment variables so git knows where to find ssl certs
    #~(job "5 0 * * *"
          (lambda ()
            (define get-line (@ (ice-9 textual-ports) get-line))
            (define (read-lines port)
              (let loop ((line (get-line port)))
                (if (eof-object? line)
                    '()
                    (cons line (loop (get-line port))))))
            ;; change to git directory
            (chdir (string-append "/srv/git/" #$repository))
            ;; execute git pull with environment variables set
            (execle (string-append #$git "/bin/git")
                    (call-with-input-file "/etc/environment" read-lines)
                    (string-append #$git "/bin/git")
                    "pull"))
           #$repository))
  (map repository->job (map car config))) ;; is run by mcron user (root), in mcron user's home directory

(define git-repo-service-type
  (service-type
   (name 'git-repo-service)
   (description "Clone and maintain git repos")
   (extensions (list
                (service-extension activation-service-type git-repo-activation)
                (service-extension mcron-service-type git-repo-pull)))))

