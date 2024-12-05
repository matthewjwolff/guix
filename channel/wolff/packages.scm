(define-module (wolff packages)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix records)
  #:use-module (guix licenses)
  #:export (certbot-namecheap-hook))

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

