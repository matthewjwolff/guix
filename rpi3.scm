(use-modules (gnu)
             (gnu bootloader)
             (gnu bootloader u-boot)
             (gnu image)
             (gnu system file-systems)
             (guix channels)
             (guix ci)
             (guix download)
             (guix gexp)
             (guix packages)
             (guix git-download)
             (guix build-system copy)
             (guix build-system gnu)
             (guix licenses)
             (wolff packages)
             (wolff services)
             (srfi srfi-1))

(use-service-modules networking ssh avahi certbot web)
(use-package-modules bootloaders ssh raspberry-pi package-management admin nvi emacs)

(define-public raspberrypi-kernel-bin
(package
  (name "raspberrypi-kernel")
  (version "1.20240529")
  (source (origin
           (method git-fetch)
           (uri (git-reference
                 (url "https://github.com/raspberrypi/firmware")
                 (commit version)))
           (modules '((guix build utils)
                      (ice-9 ftw)
                      (srfi srfi-26)))
           ;; deleted snippet
           (file-name (git-file-name name version))
           (sha256
            (base32
             ;; different sha256
             "0l5n7wvcbxmdrmagf052586yf2vddlv9d18wqlnspg5sj7nsih1a"))))
  (arguments
   '(#:install-plan
     ;; TODO this is specific to rpi 3+
     ;; parameters file expects /gnu/store/*raspberrypi-kernel/Image to be the kernel image
       '(("boot/kernel8.img" "Image")
         ;; guix module database compile expects the folder to be named differently
         ;; note: causes collisions, rpi has prebuilt modules, but guix build will make them too
         ;; does not have to do with names, build system requires exactly one folder
         ("modules/6.6.31-v8+" "lib/modules/6.6.31-v8+")
         ;; need System.map
         ("extra/" "."))))
  (build-system copy-build-system)
  (synopsis "Kernel for the Raspberry Pi boards")
  (description "Pre-compiled binaries of the current Raspberry Pi kernel
and modules, userspace libraries, and bootloader/GPU firmware.")
  (home-page "https://github.com/raspberrypi/firmware")
  (supported-systems '("armhf-linux" "aarch64-linux"))
  (license
    (list gpl2))))


;; booted with manual steps
;; manual workarounds:
;; need to make filesystem on guix computer, newer filesystem cannot be checked
;; install properietary bootloader files (this is one-time install, so probably doesn't matter)
;; install modules directory (picked the wrong precompiled ones)
;; copy to efi partition (should be only one time issue)
;; grub file is not in the right place (grub in efi partition sources /boot/grub, which is not present)
;; had to use mkfs.ext4 -O ^metadata_csum_seed since guix grub is affected by a bug
;; guix's config.txt is incorrect
;; raspberrypi kernel does not go into the right location (so grub won't boot the kernel right)
;; wifi doesn't work (need wifi firmware in pantherx repo, but probably packaged in linux-firmware or maybe raspberrypi firmware)
(define linux-firmware
  (package
    (name "linux-firmware")
    (version "20240513")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://kernel.org/linux/kernel/firmware/"
                                  "linux-firmware-" version ".tar.xz"))
              (sha256
               (base32
                "0knc7qgk4bkcdip0hvjnwk4jv062m8cdskywrqvms4v8jswys1cz"))))
    (build-system gnu-build-system)
    (arguments
     (list #:tests? #f
           #:strip-binaries? #f
           #:validate-runpath? #f
           #:make-flags #~(list (string-append "DESTDIR=" #$output))))
    (native-inputs
     (list rdfind))
    (home-page
     "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git")
    (synopsis "Nonfree firmware blobs for Linux")
    (description "Nonfree firmware blobs for enabling support for various
hardware in the Linux kernel.  This is a large package which may be overkill
if your hardware is supported by one of the smaller firmware packages.")
    (license
     (list gpl2))))

(operating-system
 (host-name "pi")
 (timezone "America/Chicago")
 (locale "en_US.utf8")

 (issue "Successful cross compile deploy!")

 (bootloader (bootloader-configuration
              ;; TODO subtle bug in bootloader which writes arm64bit=0 when doing guix deploy
              ;; work around it by having custom.txt overwrite with the right value
              ;; current bootloader does not write custom.txt
              (bootloader grub-efi-bootloader-chain-raspi-64)
              (targets '("/boot/efi")))) ;; behavior changes if target does not support symlinks (assumes FAT and therefore an EFI partition, thus installs things relative to that mount point)

 (file-systems (append (list
                        (file-system
                         (device (file-system-label "RASPIROOT"))
                         (mount-point "/")
                         (type "ext4"))
                        (file-system
                          (device (file-system-label "EFI"))
                          (mount-point "/boot/efi")
                          (type "vfat")))
                         %base-file-systems))

 (kernel raspberrypi-kernel-bin)
 (firmware (list
            ;; could be minimized, only need the wifi driver
            linux-firmware))

 (initrd-modules '())

 ;; TODO preset an ssh key somewhere
 (users (cons (user-account
               (name "mjw")
               (group "users")
               (supplementary-groups '("wheel")))
               %base-user-accounts))

 ;; TODO just make it root-loginable, with a ssh key placed somewhere
 (sudoers-file (plain-file "sudoers" (string-append (plain-file-content %sudoers-specification) "mjw ALL = NOPASSWD: ALL")))

 ;; lookup .local addresses
 (name-service-switch %mdns-host-lookup-nss)

 ;; nvi cannot be cross compiled
 ;; TODO openssl is both a license and a package
 (packages (append (list acme.sh (@ (gnu packages tls) openssl)) (delete nvi %base-packages)))

 (services (append (list (service dhcp-client-service-type) ;; need a networking for ntp (and others)
                         ;;(service network-manager-service-type) ;; error building networkmanager
                         ;;(service wpa-supplicant-service-type)
                         (service ntp-service-type)
                         ;; ordinarily not a good idea to introduce a pointless configuration-translator
                         ;; but a fileserver is basic, and this handles the mime.types issue with a store-ref
                         (service nginx-service-type
                                  (nginx-configuration
                                   (server-blocks (list
                                   (nginx-server-configuration
                                    (server-name (list "files.wolff.io"))
                                    (listen '("443 ssl"))
                                    ;; don't know what these two do, but it wasnt in the original config
                                    ;; checking with web.scm, these are the sentinel values for each that disable the config line
                                    (root "")
                                    (index '())
                                    (ssl-certificate "/etc/acme.sh/*.wolff.io_ecc/*.wolff.io.cer")
                                    (ssl-certificate-key "/etc/acme.sh/*.wolff.io_ecc/*.wolff.io.key")
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
                         (service acme.sh-service-type
                                  (acme.sh-service-configuration
                                   (certs '("*.wolff.io"))))

                         ;; TODO hard stop: python build system does not support cross builds
                         ;; (but it shouldn't need to, its python)
                         ;; for now, work on making the main laptop fully reproducible with sops

                         #|
                         (service certbot-service-type
                                   (certbot-configuration
                                    (webroot "/var/www") ;; needs a non-#f webroot because of unconditional mkdir-p
                                    (default-location #f)
                                    (certificates (list (certificate-configuration
                                                         (name "wolff.io") ;; provide a name to strip wildcard from paths
                                                         (domains '("*.wolff.io"))
                                                         (challenge "dns-01")
                                                         ;; TODO certbot-namecheap-hook (patched) contains hidden dependency on /home/mjw/namecheap.ini (the secret credentials for my namecheap account)
                                                         ;; should also be fixed with sops
                                                         (authentication-hook (file-append certbot-namecheap-hook "/authenticator.sh"))
                                                         (cleanup-hook (file-append certbot-namecheap-hook "/cleanup.sh")))))))
                         |#
                         (service openssh-service-type
                                  (openssh-configuration
                                   (password-authentication? #t)
                                   (permit-root-login #t)
                                   (openssh openssh-sans-x)))
                         (service avahi-service-type))
                   ;; make sure noonietop can continue to deploy things
                         (modify-services %base-services
                           (guix-service-type config =>
                                              (guix-configuration
                                               (inherit config)
                                               (authorized-keys
                                                (append (list (local-file "./noonietop.pub"))
                                                        %default-authorized-guix-keys))))))))


