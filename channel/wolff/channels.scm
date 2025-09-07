(define-module (wolff channels)
  #:use-module (guix channels)
  #:export (%wolff-channels))

(define %wolff-channels
  (cons* (channel
          (name 'rosenthal)
          (url "https://codeberg.org/hako/rosenthal.git")
          (branch "trunk")
          (introduction
           (make-channel-introduction
            "7677db76330121a901604dfbad19077893865f35"
            (openpgp-fingerprint
             "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7"))))
         (channel
          (name 'sops-guix)
          (url "https://github.com/fishinthecalculator/sops-guix")
          (branch "main")
          ;; Enable signature verification:
          (introduction
           (make-channel-introduction
            "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
            (openpgp-fingerprint
             "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2"))))
         (channel
           (name 'wolff)
           (url "https://github.com/matthewjwolff/guix/")
           (introduction
            (make-channel-introduction
             "78005ce24942dcbbcafe6d92b8f1beac4f365ba3"
             (openpgp-fingerprint
              "873A 05AB 6B98 858E 0ECE  2683 E854 A44F 5C0D 16BA"))))
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
