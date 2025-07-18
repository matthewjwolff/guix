(define-module (wolff packages)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-compression)
  #:use-module (gnu packages crates-check)
  #:use-module (gnu packages crates-crypto)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages web)
  #:use-module (gnu packages dns)
  #:use-module (guix records)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (certbot-cloudflare-hook
            certbot-namecheap-hook
            mcrcon
            acme.sh
            lazymc
            lazymc-0.2.11
            lazymc-0.2.10))

(define certbot-cloudflare-hook
  (package
   (name "certbot-cloudflare-hook")
   (version "c93e98794b28e9ea991aa8f65c3fa9c3bcab8921")
   (source
    (origin
     (sha256 "1l90ysbf6i00ii99qwfzid22i59z1qfq32zlxlr9yzrzxz72hng6")
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
                                             (display inputs)
                                             (wrap-program (search-input-file outputs "cloudflare-clean-dns.sh") `("PATH" ":" = ,(list
                                                                                                      (string-append (assoc-ref inputs "curl") "/bin")
                                                                                                      (string-append (assoc-ref inputs "jq") "/bin")
                                                                                                      (string-append (assoc-ref inputs "sed") "/bin")
                                                                                                      (string-append (assoc-ref inputs "bind") "/bin"))))
                                             (wrap-program (search-input-file outputs "cloudflare-update-dns.sh") `("PATH" ":" = ,(list
                                                                                                      (string-append (assoc-ref inputs "curl") "/bin")
                                                                                                      (string-append (assoc-ref inputs "jq") "/bin")
                                                                                                      (string-append (assoc-ref inputs "sed") "/bin")
                                                                                                      (string-append (assoc-ref inputs "grep") "/bin")
                                                                                                      (string-append (assoc-ref inputs "bind") "/bin")))))))))
   (inputs (list curl jq sed grep (list isc-bind "utils")))
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

(define-public rust-named-binary-tag-0.2
  (package
    (name "rust-named-binary-tag")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "named-binary-tag" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hyfzq7ncj3h1lzgmcni188ra3jai8mrcfz0lbwm9n9vqvx9hcjj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-linked-hash-map" ,rust-linked-hash-map-0.5))
                      #:cargo-development-inputs (("rust-criterion" ,rust-criterion-0.3))))
    (home-page "https://github.com/eihwaz/named-binary-tag")
    (synopsis
     "Format is used by minecraft for the various files in which it saves data")
    (description
     "This package provides Format is used by minecraft for the various files in which it saves data.")
    (license license:expat)))

(define-public rust-minecraft-protocol-derive-for-lazymc-0.2.10
  (package
    (name "rust-minecraft-protocol-derive")
    (version "edfdf876c0c21be02afdd885e3400983f3137ec9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/timvisee/rust-minecraft-protocol/archive/" version  ".tar.gz"))
       (file-name (string-append name "-0.0.0.tar.gz"))
       (snippet #~(begin (use-modules (guix build utils)) (copy-recursively "protocol-derive" ".")))
       (sha256
        (base32 "027jlngw58ndhbdiv5hgklzrxay3d2l3n74ym4x2qdi2cdhhbc6y"))))
    (build-system cargo-build-system)
    (arguments
     `(;;#:cargo-build-flags '("--release" "-v" "-v")
       ;;                    #:install-source? #f
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/eihwaz/minecraft-protocol")
    (synopsis "Derive macro for reading and writing Minecraft packets")
    (description
     "This package provides Derive macro for reading and writing Minecraft packets.")
    (license license:expat)))

(define-public rust-minecraft-protocol-derive-for-lazymc-0.2.11
  (package
    (name "rust-minecraft-protocol-derive")
    (version "4f93bb3438d25fd23410d7c30964971e59cfb327")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/timvisee/rust-minecraft-protocol/archive/" version  ".tar.gz"))
       (file-name (string-append name "-0.0.0.tar.gz"))
       (snippet #~(begin (use-modules (guix build utils)) (copy-recursively "protocol-derive" ".")))
       (sha256
        (base32 "12lh0byy3q75dmv3nl1vyjv9ks6hdx396vyw8c584s8wrnv0x9va"))))
    (build-system cargo-build-system)
    (arguments
     `(;;#:cargo-build-flags '("--release" "-v" "-v")
       ;;                    #:install-source? #f
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/eihwaz/minecraft-protocol")
    (synopsis "Derive macro for reading and writing Minecraft packets")
    (description
     "This package provides Derive macro for reading and writing Minecraft packets.")
    (license license:expat)))

(define-public rust-minecraft-protocol-for-lazymc-0.2.10
  (package
    (name "rust-minecraft-protocol")
    (version "edfdf876c0c21be02afdd885e3400983f3137ec9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/timvisee/rust-minecraft-protocol/archive/" version  ".tar.gz"))
       (file-name (string-append name "-0.0.0.tar.gz"))
       (snippet #~(begin
                    (use-modules (guix build utils))
                    ;; strip to only this package
                    (copy-recursively "protocol" ".")
                    ;; we vendor protocol-derive
                    (substitute* "Cargo.toml"
                      (("\\{ version = \"0\\.0\\.0\", path = \"\\.\\./protocol-derive\" \\}") "\"0.0.0\"")
                      (("readme = \"\\.\\./README\\.md\"") ""))))
       (sha256
        (base32 "027jlngw58ndhbdiv5hgklzrxay3d2l3n74ym4x2qdi2cdhhbc6y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:tests? #f #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-minecraft-protocol-derive" ,rust-minecraft-protocol-derive-for-lazymc-0.2.10)
                       ("rust-named-binary-tag" ,rust-named-binary-tag-0.2)
                       ("rust-num-derive" ,rust-num-derive-0.2)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-uuid" ,rust-uuid-0.7))))
    (home-page "https://github.com/eihwaz/minecraft-protocol")
    (synopsis "Library for decoding and encoding Minecraft packets")
    (description
     "This package provides Library for decoding and encoding Minecraft packets.")
    (license license:expat)))

(define-public rust-minecraft-protocol-for-lazymc-0.2.11
  (package
    (name "rust-minecraft-protocol")
    (version "4f93bb3438d25fd23410d7c30964971e59cfb327")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/timvisee/rust-minecraft-protocol/archive/" version  ".tar.gz"))
       (file-name (string-append name "-0.0.0.tar.gz"))
       (snippet #~(begin
                    (use-modules (guix build utils))
                    ;; strip to only this package
                    (copy-recursively "protocol" ".")
                    ;; we vendor protocol-derive
                    (substitute* "Cargo.toml"
                      (("\\{ version = \"0\\.0\\.0\", path = \"\\.\\./protocol-derive\" \\}") "\"0.0.0\"")
                      (("readme = \"\\.\\./README\\.md\"") ""))))
       (sha256
        (base32 "12lh0byy3q75dmv3nl1vyjv9ks6hdx396vyw8c584s8wrnv0x9va"))))
    (build-system cargo-build-system)
    (arguments
     `(#:tests? #f #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-minecraft-protocol-derive" ,rust-minecraft-protocol-derive-for-lazymc-0.2.11)
                       ("rust-named-binary-tag" ,rust-named-binary-tag-0.2)
                       ("rust-num-derive" ,rust-num-derive-0.2)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-uuid" ,rust-uuid-0.7))))
    (home-page "https://github.com/eihwaz/minecraft-protocol")
    (synopsis "Library for decoding and encoding Minecraft packets")
    (description
     "This package provides Library for decoding and encoding Minecraft packets.")
    (license license:expat)))

(define-public rust-snafu-derive-0.6
  (package
    (name "rust-snafu-derive")
    (version "0.6.10")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "snafu-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nri7ma06g5kimpcdcm8359a55nmps5f3kcngy0j6bin7jhfy20m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/shepmaster/snafu")
    (synopsis "An ergonomic error handling library")
    (description "This package provides An ergonomic error handling library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-snafu-0.6
  (package
    (name "rust-snafu")
    (version "0.6.10")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "snafu" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19wwqxwb85pl040qk5xylj0vlznib3xzy9hcv2q0h8qv4qy2vcga"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-doc-comment" ,rust-doc-comment-0.3)
                       ("rust-futures" ,rust-futures-0.1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-pin-project" ,rust-pin-project-0.4)
                       ("rust-snafu-derive" ,rust-snafu-derive-0.6))))
    (home-page "https://github.com/shepmaster/snafu")
    (synopsis "An ergonomic error handling library")
    (description "This package provides An ergonomic error handling library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-proxy-protocol-0.5
  (package
    (name "rust-proxy-protocol")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "proxy-protocol" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cnmf4kcw6yl1si9v78gs9ybyc7f19j37k2hyg2zaf6744ncfl0f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-snafu" ,rust-snafu-0.6))
       #:cargo-development-inputs (("rust-pretty-assertions" ,rust-pretty-assertions-0.7)
                                   ("rust-rand" ,rust-rand-0.8))))
    (home-page "https://github.com/Proximyst/proxy-protocol.git")
    (synopsis "PROXY protocol serializer and deserializer")
    (description
     "This package provides PROXY protocol serializer and deserializer.")
    (license (list license:expat license:asl2.0))))

(define-public rust-hematite-nbt-0.5
  (package
    (name "rust-hematite-nbt")
    (version "0.5.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "hematite-nbt" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fapfi7qb729afk9knx7kjjzjl99gn33f66wjdrvbkv7xs20f3b7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-cesu8" ,rust-cesu8-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/PistonDevelopers/hematite_nbt")
    (synopsis
     "full-featured library for working with Minecraft's Named Binary Tag (NBT) file format, including Serde support.")
    (description
     "This package provides a full-featured library for working with Minecraft's Named
Binary Tag (NBT) file format, including Serde support.")
    (license license:expat)))

(define-public rust-fastnbt-2
  (package
    (name "rust-fastnbt")
    (version "2.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fastnbt" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18r00py45jl1yhqkp5j624vaa6sxvcdcs7lfv7652mf6bnlp6jkx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-cesu8" ,rust-cesu8-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-bytes" ,rust-serde-bytes-0.11))))
    (home-page "https://github.com/owengage/fastnbt")
    (synopsis "Serde deserializer for Minecraft's NBT format")
    (description
     "This package provides Serde deserializer for Minecraft's NBT format.")
    (license (list license:expat license:asl2.0))))

(define-public rust-quartz-nbt-macros-0.1
  (package
    (name "rust-quartz-nbt-macros")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "quartz_nbt_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vfsx0bggm6s7qmif61higs9l3lyqbwafa755l6q87sdi86am6r8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/Rusty-Quartz/quartz_nbt")
    (synopsis
     "This crate contains the function-like procedural macro which parses quartz_nbt's compact compound format")
    (description
     "This crate contains the function-like procedural macro which parses quartz_nbt's
compact compound format.")
    (license license:expat)))

(define-public rust-quartz-nbt-0.2
  (package
    (name "rust-quartz-nbt")
    (version "0.2.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "quartz_nbt" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08cqyjsnxn5racklwkyhabfqk375cid9bdwqv33dknm2kcr8kwys"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-cesu8" ,rust-cesu8-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-quartz-nbt-macros" ,rust-quartz-nbt-macros-0.1)
                       ("rust-serde" ,rust-serde-1))
       #:cargo-development-inputs (("rust-criterion" ,rust-criterion-0.5)
                                   ("rust-fastnbt" ,rust-fastnbt-2)
                                   ("rust-flate2" ,rust-flate2-1)
                                   ("rust-hematite-nbt" ,rust-hematite-nbt-0.5)
                                   ("rust-once-cell" ,rust-once-cell-1)
                                   ("rust-rand" ,rust-rand-0.8)
                                   ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Rusty-Quartz/quartz_nbt")
    (synopsis
     "Provides support for serializing and deserializing Minecraft NBT data in binary and string form")
    (description
     "This package provides support for serializing and deserializing Minecraft NBT
data in binary and string form.")
    (license license:expat)))

(define-public rust-err-derive-0.3
  (package
    (name "rust-err-derive")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "err-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17ma9inqvjwklbzsh899cwkqw7113zi7qhqwii4r1vgkimy8hjn3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-error" ,rust-proc-macro-error-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-rustversion" ,rust-rustversion-1)
                       ("rust-skeptic" ,rust-skeptic-0.13)
                       ("rust-skeptic" ,rust-skeptic-0.13)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-synstructure" ,rust-synstructure-0.12))))
    (home-page "https://gitlab.com/torkleyy/err-derive")
    (synopsis "Derive macro for `std::error::Error`")
    (description "This package provides Derive macro for `std::error::Error`.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rcon-0.5
  (package
    (name "rust-rcon")
    (version "0.5.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rcon" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rkihy95grrlw76d07pipj88w1aznhl3my2c5px91gc6dwadszvb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-err-derive" ,rust-err-derive-0.3))
                      #:cargo-development-inputs (("rust-async-std" ,rust-async-std-1))))
    (home-page "https://github.com/panicbit/rust-rcon")
    (synopsis "An rcon protocol implementation")
    (description "This package provides An rcon protocol implementation.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rcon-0.6
  (package
    (name "rust-rcon")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rcon" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ys18zr00ydgz73xlzk3xg0migil4kczc9xg9dpps7h43ksap2v1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-err-derive" ,rust-err-derive-0.3)
                       ("rust-tokio" ,rust-tokio-1))
       #:cargo-development-inputs (("rust-async-std" ,rust-async-std-1)
                                   ("rust-futures-timer" ,rust-futures-timer-3))))
    (home-page "https://github.com/panicbit/rust-rcon")
    (synopsis "An rcon protocol implementation")
    (description "This package provides An rcon protocol implementation.")
    (license (list license:expat license:asl2.0))))



(define lazymc-0.2.10
  (package
    (name "lazymc")
    (version "0.2.10")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/timvisee/lazymc/archive/refs/tags/v" version ".tar.gz"))
       (snippet #~(begin
                    (use-modules (guix build utils))
                    (substitute* "Cargo.toml" (("\\{ git = ") "\"0.1\" #"))))
       (sha256 "119wxj2q2zgc55nk1cvd74vxnlc8ri7nr66r3x42z076dldyqyrn")))
    (build-system cargo-build-system)
    (arguments `(#:cargo-inputs
                 (("rust-anyhow" ,rust-anyhow-1)
                  ("rust-base64" ,rust-base64-0.22)
                  ("rust-bytes" ,rust-bytes-1)
                  ("rust-chrono" ,rust-chrono-0.4)
                  ("rust-clap" ,rust-clap-4)
                  ("rust-colored" ,rust-colored-2)
                  ("rust-derive-builder" ,rust-derive-builder-0.12)
                  ("rust-dotenv" ,rust-dotenv-0.15)
                  ("rust-flate2" ,rust-flate2-1)
                  ("rust-futures" ,rust-futures-0.3)
                  ("rust-log" ,rust-log-0.4)
                  ("rust-minecraft-protocol" ,rust-minecraft-protocol-for-lazymc-0.2.10)
                  ("rust-named-binary-tag" ,rust-named-binary-tag-0.2)
                  ("rust-nix" ,rust-nix-0.28)
                  ("rust-notify" ,rust-notify-4)
                  ("rust-pretty-env-logger" ,rust-pretty-env-logger-0.4)
                  ("rust-proxy-protocol" ,rust-proxy-protocol-0.5)
                  ("rust-quartz-nbt" ,rust-quartz-nbt-0.2)
                  ("rust-rand" ,rust-rand-0.8)
                  ("rust-serde" ,rust-serde-1)
                  ("rust-serde-json" ,rust-serde-json-1)
                  ("rust-shlex" ,rust-shlex-1)
                  ("rust-thiserror" ,rust-thiserror-1)
                  ("rust-tokio" ,rust-tokio-1)
                  ("rust-toml" ,rust-toml-0.5)
                  ("rust-version-compare" ,rust-version-compare-0.1)
                  ("rust-rcon" ,rust-rcon-0.5)
                  ("rust-md5" ,rust-md-5-0.10)
                  ("rust-uuid" ,rust-uuid-0.7)
                  ("rust-libc" ,rust-libc-0.2))))
    (synopsis "")
    (description "")
    (home-page "https://github.com/timvisee/lazymc")
    (license license:gpl3)))

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
    (arguments `(#:cargo-inputs
                 (("rust-anyhow" ,rust-anyhow-1)
                  ("rust-base64" ,rust-base64-0.22)
                  ("rust-bytes" ,rust-bytes-1)
                  ("rust-chrono" ,rust-chrono-0.4)
                  ("rust-clap" ,rust-clap-4)
                  ("rust-colored" ,rust-colored-2)
                  ("rust-derive-builder" ,rust-derive-builder-0.20)
                  ("rust-dotenv" ,rust-dotenv-0.15)
                  ("rust-flate2" ,rust-flate2-1)
                  ("rust-futures" ,rust-futures-0.3)
                  ("rust-log" ,rust-log-0.4)
                  ("rust-minecraft-protocol" ,rust-minecraft-protocol-for-lazymc-0.2.11)
                  ("rust-named-binary-tag" ,rust-named-binary-tag-0.2)
                  ("rust-nix" ,rust-nix-0.28)
                  ("rust-notify" ,rust-notify-4)
                  ("rust-pretty-env-logger" ,rust-pretty-env-logger-0.5)
                  ("rust-proxy-protocol" ,rust-proxy-protocol-0.5)
                  ("rust-quartz-nbt" ,rust-quartz-nbt-0.2)
                  ("rust-rand" ,rust-rand-0.8)
                  ("rust-serde" ,rust-serde-1)
                  ("rust-serde-json" ,rust-serde-json-1)
                  ("rust-shlex" ,rust-shlex-1)
                  ("rust-thiserror" ,rust-thiserror-1)
                  ("rust-tokio" ,rust-tokio-1)
                  ("rust-toml" ,rust-toml-0.8)
                  ("rust-version-compare" ,rust-version-compare-0.2)
                  ("rust-rcon" ,rust-rcon-0.6)
                  ("rust-md5" ,rust-md-5-0.10)
                  ("rust-uuid" ,rust-uuid-1)
                  ("rust-libc" ,rust-libc-0.2))))
    (synopsis "")
    (description "")
    (home-page "https://github.com/timvisee/lazymc")
    (license license:gpl3)))


(define lazymc lazymc-0.2.11)
