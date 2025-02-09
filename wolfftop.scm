(use-modules (gnu)
             (gnu system nss)
             (srfi srfi-1)
             (nongnu packages linux)
             (guix channels)
             (wolff channels)
             (wolff packages)
             (wolff services))
(use-service-modules desktop sddm xorg ssh networking shepherd virtualization docker)
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

             (service containerd-service-type)
             (service docker-service-type)
             (service docker-container-service-type
                      (docker-service-configuration
                       (name 'jellyfin)
                       (container "jellyfin/jellyfin")
                       (volumes '(("config" . "/config")
                                  ("cache" . "/cache")))
                       (mounts '(("/mnt" . "/opt")))))
             (service qemu-binfmt-service-type (qemu-binfmt-configuration (platforms (lookup-qemu-platforms "aarch64"))))

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
