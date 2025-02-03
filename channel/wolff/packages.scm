(define-module (wolff packages)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages bash)
  #:use-module (guix records)
  #:use-module (guix licenses)
  #:export (certbot-namecheap-hook
            mcrcon
            acme.sh
            lazymc))

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
   (license gpl3)
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
    (license zlib)))

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
   (license gpl3)
   (description "Acme.sh is a pure shell implementation of the ACME protocol.")
   (home-page "https://github.com/acmesh-official/acme.sh")))

(define lazymc
  (package
    (name "lazymc")
    (version "0.2.11")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/timvisee/lazymc/archive/refs/tags/v" version ".tar.gz"))
       (sha256 "0khdyfklxafg3h44i4i1gr8a9axvmkdcvx8ca2pm5pjw7f8pdv8q")))
    (build-system cargo-build-system)
    (synopsis "")
    (description "")
    (home-page "https://github.com/timvisee/lazymc")
    (license gpl3)))

