(define-module (wolff packages)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix records)
  #:use-module (guix licenses)
  #:export (certbot-namecheap-hook
            mcrcon))

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

