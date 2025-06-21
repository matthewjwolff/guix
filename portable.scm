(use-modules (gnu)
             (gnu system nss)
             (srfi srfi-1)
             (nongnu packages linux)
             (wolff channels))

(use-service-modules desktop sddm xorg)


(operating-system
 (host-name "Wolffdrive")
 (timezone "America/Chicago")
 (locale "en_US.utf8")

 ;;bootloader
 (bootloader (bootloader-configuration
              (bootloader grub-efi-removable-bootloader)
              (targets (list "/boot/efi"))))

 (file-systems (cons* (file-system
                        ;; TODO fat32 uuids are not valid, and guix rejects
                       (device (file-system-label "FD-EFI"))
                       (mount-point "/boot/efi")
                       (type "vfat"))
                      (file-system
                       (device (uuid "e6f6aa2c-d559-4c8b-9bf0-789a71dc6db5"))
                       (mount-point "/")
                       (type "ext4"))
                      %base-file-systems))

 ;; packages

 (users (cons (user-account
               (name "mjw")
               (group "users")
               (supplementary-groups '("wheel" "netdev" "audio" "video")))
              %base-user-accounts))
 (kernel linux)
 (firmware (cons linux-firmware %base-firmware))
 (name-service-switch %mdns-host-lookup-nss)

 (services (cons*
            ;; services
             (service plasma-desktop-service-type)
             (service sddm-service-type
                      (sddm-configuration
                       (theme "breeze")))

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
