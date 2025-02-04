;; This is an operating system configuration template
;; for a "desktop" setup with Plasma.

(use-modules (gnu)
             (gnu system nss)
             (srfi srfi-1)
             (nongnu packages linux)
             (guix channels)
             (wolff channels))
(use-service-modules desktop sddm xorg ssh networking shepherd virtualization)
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
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video")))
               %base-user-accounts))

  (kernel linux)
  (firmware (cons linux-firmware %base-firmware))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss)
  ;; This is where we specify system-wide packages.
  (packages (cons* neofetch
                   htop
                   tmux
                   xprop
                   strace
                   %base-packages))

  (services (cons*
             ;; for debug
             ;; (simple-service
             ;;  'add-qt-debug-env
             ;;  session-environment-service-type
             ;;  '(("QT_MESSAGE_PATTERN"
             ;;     . "[[%{time process} %{type}] %{appname}: %{category} %{function} - %{message}]")
             ;;    ("QT_DEBUG_PLUGINS" . "1")
             ;;    ("QML_IMPORT_TRACE" . "1")))
             (service openssh-service-type
                      (openssh-configuration
                       (openssh openssh-sans-x)
                       (password-authentication? #f)))
             (service plasma-desktop-service-type)
             (service sddm-service-type
                      (sddm-configuration
                       (theme "breeze")))

             (service nftables-service-type (nftables-configuration (ruleset (local-file "nftables.conf"))))

             (service qemu-binfmt-service-type (qemu-binfmt-configuration (platforms (lookup-qemu-platforms "aarch64"))))

             (simple-service 'paper-1.21.4 shepherd-root-service-type
                             (list (shepherd-service (provision '(paper-1.21.4))
                                                     (requirement '(user-processes networking))
                                                     (auto-start? #f)
                                                     (respawn? #f)
                                                     (stop #~(make-kill-destructor #:grace-period 180))
                                                     (start #~(make-forkexec-constructor
                                                               (list (string-append #$openjdk21 "/bin/java") "-Xmx4092M" "-jar" "paper-1.21.4-128.jar" "nogui")
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
                                                                     (append (list (plain-file "non-guix.pub"
"(public-key 
 (ecc 
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
  )
 )")) %default-authorized-guix-keys )))))))))
