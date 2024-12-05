(define-module (wolff channels)
  #:use-module (guix channels)
  #:export (%wolff-channels))

(define %wolff-channels
  (cons* (channel
           (name 'wolff)
           (url "https://github.com/matthewjwolff/guix/")
           (introduction
            (make-channel-introduction
             "8123e3e4a6317b88abf2451b9213e4a32ca1b9f8"
             (openpgp-fingerprint
              "EB4A 0F30 CFA5 E131 76BC  27ED C805 B448 ADCE 0850"))))
         (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          ;; Enable signature verification:
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
         %default-channels))
