(define-module (wolff services)
  #:use-module (gnu packages docker)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services mcron)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:export (docker-service-configuration
            docker-container-service-type
            docker-compose-service-configuration
            docker-compose-service-type
            git-repo-service-type))

(define-record-type* <docker-service-configuration>
  docker-service-configuration make-docker-service-configuration
  docker-service?
  (name docker-service-name)
  (container docker-service-container)
  (auto-start? docker-service-auto-start? (default #f))
  (respawn? docker-service-respawn? (default #f))
  ;; TODO does not support readonly mounts
  (volumes docker-service-volumes (default '()))
  (mounts docker-service-mounts (default '())))

(define (docker-service config)
  (define (volume-to-arg volume)
    (list "--volume" (string-append (car volume) ":" (cdr volume))))
  (define (mount-to-arg mount)
    (list "--mount" (string-append "type=bind,source=" (car mount) ",target=" (cdr mount))))
  (list (shepherd-service
         (provision `(,(docker-service-name config)))
         (requirement '(user-processes networking dockerd))
         (auto-start? (docker-service-auto-start? config))
         (respawn? (docker-service-respawn? config))
         (start #~(make-forkexec-constructor
                   (list (string-append #$docker-cli "/bin/docker")
                         "run"
                         "--name" #$(symbol->string (docker-service-name config))
                         "--net=host" ;; this doesn't support custom networks, you'd probably want a docker-compose file for that
                         #$@(apply append (map volume-to-arg (docker-service-volumes config)))
                         #$@(apply append (map mount-to-arg (docker-service-mounts config)))
                         #$(docker-service-container config))))
         (stop #~(make-kill-destructor)))))

(define docker-container-service-type
  (service-type
   (name 'docker-service)
   (description "A docker service")
   (extensions (list (service-extension shepherd-root-service-type docker-service))))) ;; no default value

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

