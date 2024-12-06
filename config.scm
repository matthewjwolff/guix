(use-modules (gnu)
             (gnu system nss)
             (guix build-system copy)
             (guix git-download)
             (guix gexp)
             (guix packages)
             (guix licenses)
             (guix records)
             (guix channels)
             (ice-9 eval-string)
             (ice-9 textual-ports)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (wolff services)
             (wolff packages)
             (wolff channels))
(use-service-modules admin networking ssh virtualization avahi web docker desktop dbus mcron shepherd certbot security)
(use-package-modules base certs ssh avahi java admin glib docker matrix python version-control package-management)

(define %config-dir (local-file "." "config-dir" #:recursive? #t))

(operating-system
  (host-name "noonietop")
  (timezone "America/Chicago")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets '("/boot/efi"))))
  (file-systems (append (list (file-system
                                (device (file-system-label "rootfs"))
                                (mount-point "/")
                                (type "ext4"))
                              (file-system (device (uuid "07E4-8221" 'fat)) (mount-point "/boot/efi") (type "vfat") )   )
                        %base-file-systems))
  (groups (cons "docker" %base-groups))
  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users  (cons ;;(user-account
                ;; (name "upgoon")
                ;; (group "users"))
                (user-account
                 (name "mjw")
                 (group "users")
                 ;; Adding the account to the "wheel" group
                 ;; makes it a sudoer.  Adding it to "audio"
                 ;; and "video" allows the user to play sound
                 ;; and access the webcam.
                 (supplementary-groups '("wheel" "docker" "audio" "video")))
                %base-user-accounts))

  ;; Globally-installed packages.
  ;; nss-certs now included in base-packages
  ;; python only needed to put python in /run/current-system/profile so the certbot hook works. not great..
  (packages (append (list nss-mdns avahi python) %base-packages))

  ;; for wifi
  (kernel linux)
  (firmware (list linux-firmware))
  (initrd microcode-initrd)

  ;; configure name service switch to allow looking up .local addresses
  (name-service-switch %mdns-host-lookup-nss)
  ;; allow upgoon to run any herd command involving service minecraft
  (sudoers-file (plain-file "sudoers" "root ALL=(ALL) ALL\n%wheel ALL=(ALL) ALL\nupgoon ALL=(root) /run/current-system/profile/bin/herd * minecraft"))

  ;; Add services to the baseline: networkmanager (behaves better with docker than dhcp-client?) and
  ;; an SSH server.
  ;; and an ntp server
  (services (append (list (service network-manager-service-type)
                          (service wpa-supplicant-service-type) ;; required by networkmanager
                          (service openssh-service-type
                                   (openssh-configuration
                                    (password-authentication? #f)
                                    (openssh openssh-sans-x)))
                          (service avahi-service-type)
                          (service unattended-upgrade-service-type
                                   (unattended-upgrade-configuration
                                    ;;(schedule "*/5 * * * *") ;; every five minutes for testing
                                    (schedule "30 01 * * *")
                                    ;; use system channels
                                    ;; hack to work around api
                                    ;; this gexp must return a list of channels, so it must eval the system script
                                    (channels #~(begin
                                                 (use-modules (ice-9 eval-string)
                                                              (ice-9 textual-ports)
                                                              (guix channels))
                                                 (eval-string (call-with-input-file "/etc/guix/channels.scm" get-string-all))))
                                    ;; this file refers to others via local-file (namely nginx.conf), so add everything in "." directory to the store as config-dir, and reconfigure based on "/gnu/store/...config-dir/config.scm"
                                    (operating-system-file (file-append %config-dir "/config.scm"))))
                          (service ntp-service-type)
                          (service nftables-service-type (nftables-configuration (ruleset (local-file "nftables.conf")))) ;; firewall
                          (service fail2ban-service-type ;; read common log files, identify brute-force attacks, and ban their ips
                                   (fail2ban-configuration
                                    (extra-content (list (plain-file "fail2ban-default-content" "[DEFAULT]
banaction = nftables
banaction_allports = nftables[type=allports]")))
                                    (extra-jails
                                     (list (fail2ban-jail-configuration (name "sshd"))))))

                          ;; TODO use github.com/acme-dns/acme-dns and acme-dns-client to avoid dealing with namecheap. seems cool?
                          (service certbot-service-type
                                   (certbot-configuration
                                    (webroot "/var/www") ;; needs a non-#f webroot because of unconditional mkdir-p
                                    (default-location #f)
                                    (certificates (list (certificate-configuration
                                                         (name "wolff.io") ;; provide a name to strip wildcard from paths
                                                         (domains '("*.wolff.io"))
                                                         (challenge "dns-01")
                                                         (authentication-hook (file-append certbot-namecheap-hook "/authenticator.sh"))
                                                         (cleanup-hook (file-append certbot-namecheap-hook "/cleanup.sh")))))))

                          (service git-repo-service-type
                                   '(("pokerogue" . "https://github.com/pagefaultgames/pokerogue")
                                     ("mario-builder-64" . "https://github.com/rovertronic/Mario-Builder-64")
                                     ("space-station-14" . "https://github.com/space-wizards/space-station-14")
                                     ("relics-of-the-past" . "https://github.com/Relics-Of-The-Past/Relics-of-the-Past-Release")
                                     ("nsmb-mariovsluigi" . "https://github.com/ipodtouch0218/NSMB-MarioVsLuigi/")
                                     ("project-plus-ex" . "https://github.com/KingJigglypuff/project-plus-ex")
                                     ("mk64-hd" . "https://github.com/ghostlydark/mk64-hd")))
                          (service elogind-service-type) ;; required by docker
                          (service dbus-root-service-type) ;; required by elogind (probably?)
                          ;; etc-service-type can be used to populate /etc
                          (service containerd-service-type)
                          (service docker-service-type)
                          #|
                          (service docker-container-service-type
                                   (docker-service-configuration
                                    (name 'jellyfin-run)
                                    (container "jellyfin/jellyfin")
                                    (mounts '(("jellyfin_config" . "/config")
                                              ("jellyfin_cache" . "/cache")
                                              ("/mnt" . "/opt")))))
                          |#
                          (service docker-compose-service-type
                                   (docker-compose-service-configuration
                                    (name 'jellyfin)
                                    (user "mjw")
                                    (compose-file (file-append %config-dir "/jellyfin-compose.yml"))))
                          #| TODO matrix compose file refers to other files (files/homeserver.yaml)
                          (service docker-compose-service-type
                                   (docker-compose-service-configuration
                                    (name 'matrix)
                                    (compose-file (local-file "matrix-compose.yml"))))
                          |#
                          ;;                          (service matrix-service-type)
                          ;; needed to exec arm64 grub install for building rpi images
                          (service qemu-binfmt-service-type (qemu-binfmt-configuration (platforms (lookup-qemu-platforms "aarch64"))))
                          (simple-service 'minecraft shepherd-root-service-type
                                          (list (shepherd-service (provision '(minecraft))
                                                                  (requirement '(user-processes networking))
                                                                  (auto-start? #f)
                                                                  (respawn? #f)
                                                                  (start #~(make-forkexec-constructor (list (string-append #$openjdk17 "/bin/java") "-Xmx4092M" "-jar" "spigot-1.20.1.jar" "nogui")  #:user "mjw" #:group "users" #:directory "/home/mjw/spigot" ))
                                                                  (stop #~(make-kill-destructor #:grace-period 180)))))
                          (service nginx-service-type (nginx-configuration (file (local-file "nginx.conf")))))
                    (modify-services %base-services
                      (guix-service-type config => (guix-configuration
                                                    (inherit config)
                                                    ;; documentation says this can be used to "pin its revision" (maybe this will make low-power devices not rebuild the package tree? but then how would it get packge updates?)
                                                    ;;(guix (guix-for-channels %channels))
                                                    (channels %wolff-channels)
                                                    (substitute-urls
                                                     (append (list "https://substitutes.nonguix.org")
                                                             %default-substitute-urls))
                                                    (authorized-keys
                                                     (append (list (plain-file "non-guix.pub"
                                                                               "(public-key
 (ecc
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
  )
 )"))
                                                             %default-authorized-guix-keys))))))))
