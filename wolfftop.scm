(use-modules (gnu)
             (gnu system nss)
             (srfi srfi-1)
             (nongnu packages linux)
             (guix channels)
             (wolff channels)
             (wolff packages)
             (wolff services))
(use-service-modules desktop sddm xorg ssh networking shepherd virtualization docker admin containers web certbot)
(use-package-modules gnome ssh admin fonts java)
(use-package-modules qt xorg tmux linux package-management)

(operating-system
  (host-name "Wolfftop")
  (timezone "America/Chicago")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets (list "/boot/efi"))))

  (mapped-devices (list (mapped-device
                         (source "main")
                         (target "main-root")
                         (type lvm-device-mapping))))

  (file-systems (cons* (file-system
                         (device (file-system-label "EFI"))
                         (mount-point "/boot/efi")
                         (type "vfat"))
                       (file-system
                         (device "/dev/mapper/main-root")
                         (mount-point "/")
                         (type "ext4"))
                      %base-file-systems))

  (users (cons (user-account
                (name "mjw")
                (group "users")
                (supplementary-groups '("wheel" "netdev" "docker"
                                        "audio" "video")))
               %base-user-accounts))

  (kernel linux)
  (firmware (cons linux-firmware %base-firmware))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss)
  (packages (cons* neofetch
                   htop
                   tmux
                   xprop
                   strace
                   %base-packages))

  (services (cons*
             (service openssh-service-type
                      (openssh-configuration
                       (openssh openssh-sans-x)
                       (password-authentication? #f)))
             (service plasma-desktop-service-type)
             (service sddm-service-type
                      (sddm-configuration
                       (theme "breeze")))

             (service nftables-service-type (nftables-configuration (ruleset (local-file "nftables.conf"))))

             (service git-repo-service-type
                      '(("pokerogue" . "https://github.com/pagefaultgames/pokerogue")
                        ("mario-builder-64" . "https://github.com/rovertronic/Mario-Builder-64")
                        ("space-station-14" . "https://github.com/space-wizards/space-station-14")
                        ("relics-of-the-past" . "https://github.com/Relics-Of-The-Past/Relics-of-the-Past-Release")
                        ("nsmb-mariovsluigi" . "https://github.com/ipodtouch0218/NSMB-MarioVsLuigi/")
                        ("project-plus-ex" . "https://github.com/KingJigglypuff/project-plus-ex")
                        ("mk64-hd" . "https://github.com/ghostlydark/mk64-hd")
                        ("hbc" . "https://github.com/fail0verflow/hbc")
                        ("libogc" . "https://github.com/devkitPro/libogc")
                        ("smashremix" . "https://github.com/JSsixtyfour/smashremix")
                        ("mario-eclipse" . "https://github.com/JoshuaMKW/Super-Mario-Eclipse")))
                         (service nginx-service-type
                                  (nginx-configuration
                                   (server-blocks (list
                                                   #|(nginx-server-configuration
                                                    (server-name (list "minecraft.wolff.io"))
                                                    (listen '("443 ssl"))
                                                    (root "")
                                                    (index '())
                                                    (raw-content (list "add_header Strict-Transport-Security \"max-age=604800\" always;"))
                                                    (ssl-certificate "/etc/acme.sh/*.wolff.io_ecc/*.wolff.io.cer")
                                                    (ssl-certificate-key "/etc/acme.sh/*.wolff.io_ecc/*.wolff.io.key")
                                                    (locations (list
                                                                (nginx-location-configuration
                                                                 (uri "= /502.html")
                                                                 (body (list "root /srv/web;")))
                                                                (nginx-location-configuration
                                                                 (uri "/")
                                                                 (body (list "proxy_pass http://localhost:8100/ ;"
                                                                             "proxy_set_header X-Forwarded-For $remote_addr ;"
                                                                             "error_page 502 /502.html ;"))))))|#
                                                   (nginx-server-configuration
                                                    (server-name (list "jellyfin.wolff.io"))
                                                    (listen '("443 ssl http2"))
                                                    (root "")
                                                    (index '())
                                                    (ssl-certificate "/etc/certs/wolff.io/fullchain.pem")
                                                    (ssl-certificate-key "/etc/certs/wolff.io/privkey.pem")
                                                    (locations (list
                                                                (nginx-location-configuration
                                                                 (uri "/")
                                                                 (body (list "proxy_pass http://localhost:8096;"
                                                                             "proxy_pass_request_headers on;"
                                                                             "proxy_set_header Host $host;"
                                                                             "proxy_set_header X-Real-IP $remote_addr;"
                                                                             "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                                                                             "proxy_set_header X-Forwarded-Proto $scheme;"
                                                                             "proxy_set_header X-Forwarded-Host $http_host;"
                                                                             "proxy_set_header Upgrade $http_upgrade;"
                                                                             "proxy_set_header Connection $http_connection;"
                                                                             "proxy_buffering off;"))))))
                                                   (nginx-server-configuration
                                                    (server-name (list "files.wolff.io"))
                                                    (listen '("443 ssl"))
                                                    ;; don't know what these two do, but it wasnt in the original config
                                                    ;; checking with web.scm, these are the sentinel values for each that disable the config line
                                                    (root "")
                                                    (index '())
                                                    (ssl-certificate "/etc/certs/wolff.io/fullchain.pem")
                                                    (ssl-certificate-key "/etc/certs/wolff.io/privkey.pem")
                                                    (raw-content (list "add_header Strict-Transport-Security \"max-age=604800\";"))
                                                    (locations (list
                                                                (nginx-location-configuration
                                                                 (uri "/")
                                                                 (body (list "root /srv/web;"
                                                                             "autoindex on;")))
                                                                (nginx-location-configuration
                                                                 (uri "/private")
                                                                 (body (list "alias /srv/web_private/;"
                                                                             "autoindex on;"
                                                                             "auth_basic \"Secure\";"
                                                                             ;; TODO htpasswd hidden dependency (but also a secret)
                                                                             "auth_basic_user_file /srv/htpasswd;"))))))))))

             (service containerd-service-type)

                          (service certbot-service-type
                                   (certbot-configuration
                                    (webroot "/var/www") ;; needs a non-#f webroot because of unconditional mkdir-p
                                    (default-location #f)
                                    (certificates (list (certificate-configuration
                                                         (name "wolff.io") ;; provide a name to strip wildcard from paths
                                                         (domains '("*.wolff.io"))
                                                         (challenge "dns-01")
                                                         ;; note: hidden dependency on /etc/cloudflare_dns.sh TODO managed by sops
                                                         (authentication-hook (file-append certbot-cloudflare-hook "/cloudflare-update-dns.sh"))
                                                         (cleanup-hook (file-append certbot-cloudflare-hook "/cloudflare-clean-dns.sh")))))))




             (service oci-container-service-type
                      (list (oci-container-configuration
                             (image "jellyfin/jellyfin")
                             (auto-start? #f)
                             (network "host")
                             (ports '(("8096" . "8096")))
                             (volumes '(("config" . "/config")
                                        ("cache" . "/cache")))
                             (extra-arguments '("--mount" "type=bind,source=/mnt,target=/opt")))))
             (service docker-service-type)
             (service qemu-binfmt-service-type (qemu-binfmt-configuration (platforms (lookup-qemu-platforms "aarch64"))))

             (simple-service 'atm10 shepherd-root-service-type
                             (list (shepherd-service (provision '(atm10))
                                                     (requirement '(user-processes networking))
                                                     (auto-start? #f)
                                                     (respawn? #f)
                                                     (stop #~(make-kill-destructor #:grace-period 180))
                                                     (start #~(make-forkexec-constructor
                                                               (list (string-append #$lazymc "/bin/lazymc"))
                                                               #:user "mjw" #:group "users" #:directory "/home/mjw/atm10")))))

             (simple-service 'create-ab shepherd-root-service-type
                             (list (shepherd-service (provision '(create-ab))
                                                     (requirement '(user-processes networking))
                                                     (auto-start? #f)
                                                     (respawn? #f)
                                                     (stop #~(make-kill-destructor #:grace-period 180))
                                                     (start #~(make-forkexec-constructor
                                                               ;; note: minecraft<1.20.3 needs an older lazymc
                                                               (list (string-append #$lazymc-0.2.10 "/bin/lazymc"))
                                                               #:user "mjw" #:group "users" #:directory "/home/mjw/create-ab")))))

             (simple-service 'paper-1.21.4 shepherd-root-service-type
                             (list (shepherd-service (provision '(paper-1.21.4))
                                                     (requirement '(user-processes networking))
                                                     (auto-start? #f)
                                                     (respawn? #f)
                                                     (stop #~(make-kill-destructor #:grace-period 180))
                                                     ;; TODO java path hardcoded in lazymc.toml
                                                     (start #~(make-forkexec-constructor
                                                               (list (string-append #$lazymc "/bin/lazymc"))
                                                               #:user "mjw" #:group "users" #:directory "/home/mjw/paper-1.21.4")))))

             (service unattended-upgrade-service-type
                      (unattended-upgrade-configuration
                       (schedule "30 1 * * *")
                       (channels #~(list #$@(map channel->code %wolff-channels)))
                       (operating-system-file
                        (file-append (local-file "." "config-dir" #:recursive? #t) "/wolfftop.scm"))))


             ;; Remove GDM if it's among %DESKTOP-SERVICES; on other
             ;; architectures, %DESKTOP-SERVICES contains SDDM instead.
             (remove (lambda (service)
                       (memq (service-kind service)
                             (list gdm-service-type sddm-service-type)))
                     (modify-services %desktop-services ;; note: avahi probably in here (as well as nm and wpa)
                       (guix-service-type config => (guix-configuration
                                                     (inherit config)
                                                     (channels %wolff-channels)
                                                     (substitute-urls
                                                      (append (list "https://substitutes.nonguix.org")
                                                              %default-substitute-urls))
                                                     (authorized-keys
                                                      (append (list (local-file "non-guix.pub"))
                                                              %default-authorized-guix-keys )))))))))
