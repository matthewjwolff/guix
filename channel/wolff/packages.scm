(define-module (wolff packages)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages web)
  #:use-module (gnu packages dns)
  #:use-module (guix records)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (archlinux-kernel-bin
            certbot-cloudflare-hook
            certbot-namecheap-hook
            lazymc
            mcrcon
            rust-minecraft-protocol
            acme.sh))

(define archlinux-kernel-bin
(package
  (name "archlinux-kernel")
  (version "6.16-1")
  (source (origin
           (method url-fetch)
           (uri (string-append "http://mirror.archlinuxarm.org/aarch64/core/linux-aarch64-" version "-aarch64.pkg.tar.xz"))
           (sha256
            (base32
             "041b6m7j9p275capnvg5gqnwxnki35mvgq1g4mg1rx6v6l08pp52"))))
  (arguments
   '(#:install-plan
     ;; TODO this is specific to rpi 3+
       '(("boot/Image" "Image"))))
        ;; ("boot/dtbs" "dtbs")
         ;; TODO embeds kernel version
         ;;("usr/lib/modules/6.16.0-1-aarch64-ARCH" "lib/modules/6.16.0-1-aarch64-ARCH"))))
  (build-system copy-build-system)
  (synopsis "Arch Linux ARM's kernel package")
  (description "Pre-compiled binaries of Linux.")
  (home-page "https://archlinuxarm.org")
  (supported-systems '("aarch64-linux"))
  (license
    (list license:gpl2))))
(define certbot-cloudflare-hook
  (package
   (name "certbot-cloudflare-hook")
   (version "a2f718dfe19292bedff570c41a92ff226252e777")
   (source
    (origin
     (sha256 "02qlby56gr37l3vzbjqr294jg9ljcvj2bia49s4rqs3x2cf0li7k")
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/matthewjwolff/certbot-dns-challenge-cloudflare-hooks/")
           (commit version)))))
   (build-system copy-build-system)
   (arguments (list
               #:phases
               #~(modify-phases %standard-phases
                                (add-after 'install 'wrap-scripts
                                           (lambda* (#:key inputs outputs #:allow-other-keys)
                                             (define vars (list
                                                           ;; put program inputs in $PATH
                                                           `("PATH" ":" = ,(map (compose (lambda (x) (string-append x "/bin")) cdr) inputs))
                                                           ;; set certs so curl can use https
                                                           `("SSL_CERT_DIR" ":" = (,(string-append #$nss-certs "/etc/ssl/certs/")))))
                                             (apply wrap-program (search-input-file outputs "cloudflare-clean-dns.sh") vars)
                                             (apply wrap-program (search-input-file outputs "cloudflare-update-dns.sh") vars))))))
   (inputs (list coreutils curl jq sed grep (list isc-bind "utils")))
   (synopsis "")
   (license license:gpl3)
   (description "")
   (home-page "")))


(define certbot-namecheap-hook
  (package
   (name "certbot-namecheap-hook")
   (version "b56a6953120f300940e6c1c1caae1a6000a7408d")
   (source
    (origin
     (sha256 "0syanh2jlandg5hr91d95mb7mfamkjkf35d5qq6hvvarw94ihssk")
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/ohm-vision/certbot-namecheap-hook")
           (commit version)))
     ;; TODO can use wrap-program to get programs into path
     (patches (list (local-file "ini_source.patch")))))
   (build-system copy-build-system)
   (synopsis "")
   (license license:gpl3)
   (description "")
   (home-page "")))

(define mcrcon
  (package
    (name "mcrcon")
    (version "0.7.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/Tiiffi/mcrcon/archive/v" version ".tar.gz"))
       (sha256 "0w1jjy021d65vzsr5f73csw0q0cjgp5i2h2zh177f6q35mdb4hqp")))
    (build-system gnu-build-system)
    (arguments (list #:phases #~(modify-phases %standard-phases
                                  (delete 'configure)
                                  (delete 'check))
                     #:make-flags #~(list (string-append "PREFIX=" #$output))))
    (synopsis "")
    (description "")
    (home-page "https://github.com/Tiiffi/mcrcon")
    (license license:zlib)))

(define acme.sh
  (package
   (name "acme.sh")
   (version "f981c782bb38015f4778913e9c3db26b57dde4e8")
   (source
    (origin
     (sha256 "0a15q9v9gjmls3qw5j52jlkpdl698bf271l1ydzwh680grd9snvb")
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/acmesh-official/acme.sh")
           (commit version)))))
   (build-system copy-build-system)
   (arguments (list
               #:install-plan
               #~'(("deploy/" "bin/deploy") ;; TODO this pollutes the /bin dir, but it works!
                 ("dnsapi/" "bin/dnsapi")
                 ("notify/" "bin/notify")
                 ("acme.sh" "bin/"))
               #:phases
               ;; TODO these shebang variants will point to a host-system sh
               ;; for now, since everything is /usr/env sh compatible, just use that one tiny undocumented dependency
               #~(modify-phases %standard-phases
                   (delete 'patch-shebangs)
                   (delete 'patch-generated-file-shebangs)
                   (delete 'patch-source-shebangs)))) ;; skip all shebang patches and just use system sh (because this doesn't work with cross compiling)
               #| does not work with cross compiling (a native coreutils is used, maybe i can fix copy-build-system to send cross compiled gnu-build-system inputs)
                   (add-after 'install 'wrap-script
                     (lambda* (#:key inputs outputs #:allow-other-keys)
                       (wrap-program (search-input-file outputs "bin/acme.sh")
                         ;; i bet this doesnt work with cross compiling either
                         `("PATH" ":" prefix ,(list (string-append (assoc-ref inputs "coreutils") "/bin")))))))))|#
   ;; (inputs (list bash openssl)) secret dependencies
   (synopsis "A pure Unix shell script implementing ACME client protocol")
   (license license:gpl3)
   (description "Acme.sh is a pure shell implementation of the ACME protocol.")
   (home-page "https://github.com/acmesh-official/acme.sh")))

(define rust-minecraft-protocol
  (package
    (name "rust-minecraft-protocol")
    (version "4f93bb3438d25fd23410d7c30964971e59cfb327")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/timvisee/rust-minecraft-protocol/archive/" version  ".tar.gz"))
       (file-name (string-append name "-0.0.0.tar.gz"))
       (sha256
        (base32 "12lh0byy3q75dmv3nl1vyjv9ks6hdx396vyw8c584s8wrnv0x9va"))))
    (build-system cargo-build-system)
    (arguments
     (list #:skip-build? #t
           #:cargo-package-crates ''("minecraft-protocol-derive" "minecraft-protocol")))
    (inputs (cargo-inputs 'protocol #:module '(wolff rust-crates)))
    (home-page "https://github.com/eihwaz/minecraft-protocol")
    (synopsis "Library for decoding and encoding Minecraft packets")
    (description
     "This package provides Library for decoding and encoding Minecraft packets.")
    (license license:expat)))

(define lazymc-0.2.11
  (package
    (name "lazymc")
    (version "0.2.11")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/timvisee/lazymc/archive/refs/tags/v" version ".tar.gz"))
       (snippet #~(begin
                    (use-modules (guix build utils))
                    (substitute* "Cargo.toml" (("\\{ git = ") "\"0.1\" #"))))
       (sha256 "0khdyfklxafg3h44i4i1gr8a9axvmkdcvx8ca2pm5pjw7f8pdv8q")))
    (build-system cargo-build-system)
    (arguments (list #:install-source? #f))
    (inputs (cargo-inputs 'lazymc #:module '(wolff rust-crates)))
    (synopsis "")
    (description "")
    (home-page "https://github.com/timvisee/lazymc")
    (license license:gpl3)))


(define lazymc lazymc-0.2.11)
