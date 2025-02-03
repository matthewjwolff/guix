(list (machine
       (operating-system (primitive-load "/home/mjw/guix/rpi3.scm"))
       (environment managed-host-environment-type)
       (configuration (machine-ssh-configuration
                       (host-name "pi.local")
                       (system "aarch64-linux")
                       (user "root")
                       (safety-checks? #f)
                       (identity "/home/mjw/.ssh/id_ed25519")))))
