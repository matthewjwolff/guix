;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (wolff rust-crates)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust-sources)
  #:use-module (wolff packages)
  #:export (lookup-cargo-inputs))

;;;
;;; This file is managed by ‘guix import’.  Do NOT add definitions manually.
;;;

;;;
;;; Rust libraries fetched from crates.io and non-workspace development
;;; snapshots.
;;;

(define qqqq-separator 'begin-of-crates)

(define rust-addr2line-0.24.2
  (crate-source "addr2line" "0.24.2"
                "1hd1i57zxgz08j6h5qrhsnm2fi0bcqvsh389fw400xm3arz2ggnz"))

(define rust-adler2-2.0.1
  (crate-source "adler2" "2.0.1"
                "1ymy18s9hs7ya1pjc9864l30wk8p2qfqdi7mhhcc5nfakxbij09j"))

(define rust-aho-corasick-1.1.3
  (crate-source "aho-corasick" "1.1.3"
                "05mrpkvdgp5d20y2p989f187ry9diliijgwrs254fs9s1m1x6q4f"))

(define rust-android-system-properties-0.1.5
  (crate-source "android_system_properties" "0.1.5"
                "04b3wrz12837j7mdczqd95b732gw5q7q66cv4yn4646lvccp57l1"))

(define rust-android-tzdata-0.1.1
  (crate-source "android-tzdata" "0.1.1"
                "1w7ynjxrfs97xg3qlcdns4kgfpwcdv824g611fq32cag4cdr96g9"))

(define rust-anstream-0.6.20
  (crate-source "anstream" "0.6.20"
                "14k1iqdf3dx7hdjllmql0j9sjxkwr1lfdddi3adzff0r7mjn7r9s"))

(define rust-anstyle-1.0.11
  (crate-source "anstyle" "1.0.11"
                "1gbbzi0zbgff405q14v8hhpi1kz2drzl9a75r3qhks47lindjbl6"))

(define rust-anstyle-parse-0.2.7
  (crate-source "anstyle-parse" "0.2.7"
                "1hhmkkfr95d462b3zf6yl2vfzdqfy5726ya572wwg8ha9y148xjf"))

(define rust-anstyle-query-1.1.4
  (crate-source "anstyle-query" "1.1.4"
                "1qir6d6fl5a4y2gmmw9a5w93ckwx6xn51aryd83p26zn6ihiy8wy"))

(define rust-anstyle-wincon-3.0.10
  (crate-source "anstyle-wincon" "3.0.10"
                "0ajz9wsf46a2l3pds7v62xbhq2cffj7wrilamkx2z8r28m0k61iy"))

(define rust-anyhow-1.0.99
  (crate-source "anyhow" "1.0.99"
                "001icqvkfl28rxxmk99rm4gvdzxqngj5v50yg2bh3dzcvqfllrxh"))

(define rust-autocfg-1.5.0
  (crate-source "autocfg" "1.5.0"
                "1s77f98id9l4af4alklmzq46f21c980v13z2r1pcxx6bqgw0d1n0"))

(define rust-backtrace-0.3.75
  (crate-source "backtrace" "0.3.75"
                "00hhizz29mvd7cdqyz5wrj98vqkihgcxmv2vl7z0d0f53qrac1k8"))

(define rust-base64-0.22.1
  (crate-source "base64" "0.22.1"
                "1imqzgh7bxcikp5vx3shqvw9j09g9ly0xr0jma0q66i52r7jbcvj"))

(define rust-bitflags-1.3.2
  (crate-source "bitflags" "1.3.2"
                "12ki6w8gn1ldq7yz9y680llwk5gmrhrzszaa17g1sbrw2r2qvwxy"))

(define rust-bitflags-2.9.3
  (crate-source "bitflags" "2.9.3"
                "0pgjwsd9qgdmsmwpvg47p9ccrsc26yfjqawbhsi9qds5sg6brvrl"))

(define rust-block-buffer-0.10.4
  (crate-source "block-buffer" "0.10.4"
                "0w9sa2ypmrsqqvc20nhwr75wbb5cjr4kkyhpjm1z1lv2kdicfy1h"))

(define rust-bumpalo-3.19.0
  (crate-source "bumpalo" "3.19.0"
                "0hsdndvcpqbjb85ghrhska2qxvp9i75q2vb70hma9fxqawdy9ia6"))

(define rust-byteorder-1.5.0
  (crate-source "byteorder" "1.5.0"
                "0jzncxyf404mwqdbspihyzpkndfgda450l0893pz5xj685cg5l0z"))

(define rust-bytes-1.10.1
  (crate-source "bytes" "1.10.1"
                "0smd4wi2yrhp5pmq571yiaqx84bjqlm1ixqhnvfwzzc6pqkn26yp"))

(define rust-cc-1.2.35
  (crate-source "cc" "1.2.35"
                "18vfhd6njr0lhfvfvxchj3bay4fw6hcpyy4130sl134alqj903sr"))

(define rust-cesu8-1.1.0
  (crate-source "cesu8" "1.1.0"
                "0g6q58wa7khxrxcxgnqyi9s1z2cjywwwd3hzr5c55wskhx6s0hvd"))

(define rust-cfg-aliases-0.1.1
  (crate-source "cfg_aliases" "0.1.1"
                "17p821nc6jm830vzl2lmwz60g3a30hcm33nk6l257i1rjdqw85px"))

(define rust-cfg-if-0.1.10
  (crate-source "cfg-if" "0.1.10"
                "08h80ihs74jcyp24cd75wwabygbbdgl05k6p5dmq8akbr78vv1a7"))

(define rust-cfg-if-1.0.3
  (crate-source "cfg-if" "1.0.3"
                "1afg7146gbxjvkbjx7i5sdrpqp9q5akmk9004fr8rsm90jf2il9g"))

(define rust-chrono-0.4.41
  (crate-source "chrono" "0.4.41"
                "0k8wy2mph0mgipq28vv3wirivhb31pqs7jyid0dzjivz0i9djsf4"))

(define rust-clap-4.5.46
  (crate-source "clap" "4.5.46"
                "0mvfywfsyyps8wkz7nx75aj1jc715maxis8yr92fbli1kk7lypic"))

(define rust-clap-builder-4.5.46
  (crate-source "clap_builder" "4.5.46"
                "0hbxwmi3amm9ls0vx3gkz9z55ylj4lpbq0b0d1ghbyzwwsh57jzy"))

(define rust-clap-lex-0.7.5
  (crate-source "clap_lex" "0.7.5"
                "0xb6pjza43irrl99axbhs12pxq4sr8x7xd36p703j57f5i3n2kxr"))

(define rust-colorchoice-1.0.4
  (crate-source "colorchoice" "1.0.4"
                "0x8ymkz1xr77rcj1cfanhf416pc4v681gmkc9dzb3jqja7f62nxh"))

(define rust-colored-2.2.0
  (crate-source "colored" "2.2.0"
                "0g6s7j2qayjd7i3sivmwiawfdg8c8ldy0g2kl4vwk1yk16hjaxqi"))

(define rust-core-foundation-sys-0.8.7
  ;; TODO: Check bundled sources.
  (crate-source "core-foundation-sys" "0.8.7"
                "12w8j73lazxmr1z0h98hf3z623kl8ms7g07jch7n4p8f9nwlhdkp"))

(define rust-crc32fast-1.5.0
  (crate-source "crc32fast" "1.5.0"
                "04d51liy8rbssra92p0qnwjw8i9rm9c4m3bwy19wjamz1k4w30cl"))

(define rust-crypto-common-0.1.6
  (crate-source "crypto-common" "0.1.6"
                "1cvby95a6xg7kxdz5ln3rl9xh66nz66w46mm3g56ri1z5x815yqv"))

(define rust-darling-0.20.11
  (crate-source "darling" "0.20.11"
                "1vmlphlrlw4f50z16p4bc9p5qwdni1ba95qmxfrrmzs6dh8lczzw"))

(define rust-darling-core-0.20.11
  (crate-source "darling_core" "0.20.11"
                "0bj1af6xl4ablnqbgn827m43b8fiicgv180749f5cphqdmcvj00d"))

(define rust-darling-macro-0.20.11
  (crate-source "darling_macro" "0.20.11"
                "1bbfbc2px6sj1pqqq97bgqn6c8xdnb2fmz66f7f40nrqrcybjd7w"))

(define rust-derive-builder-0.20.2
  (crate-source "derive_builder" "0.20.2"
                "0is9z7v3kznziqsxa5jqji3ja6ay9wzravppzhcaczwbx84znzah"))

(define rust-derive-builder-core-0.20.2
  (crate-source "derive_builder_core" "0.20.2"
                "1s640r6q46c2iiz25sgvxw3lk6b6v5y8hwylng7kas2d09xwynrd"))

(define rust-derive-builder-macro-0.20.2
  (crate-source "derive_builder_macro" "0.20.2"
                "0g1zznpqrmvjlp2w7p0jzsjvpmw5rvdag0rfyypjhnadpzib0qxb"))

(define rust-digest-0.10.7
  (crate-source "digest" "0.10.7"
                "14p2n6ih29x81akj097lvz7wi9b6b9hvls0lwrv7b6xwyy0s5ncy"))

(define rust-doc-comment-0.3.3
  (crate-source "doc-comment" "0.3.3"
                "043sprsf3wl926zmck1bm7gw0jq50mb76lkpk49vasfr6ax1p97y"))

(define rust-dotenv-0.15.0
  (crate-source "dotenv" "0.15.0"
                "13ysjx7n2bqxxqydvnnbdwgik7i8n6h5c1qhr9g11x6cxnnhpjbp"))

(define rust-env-logger-0.10.2
  (crate-source "env_logger" "0.10.2"
                "1005v71kay9kbz1d5907l0y7vh9qn2fqsp2yfgb8bjvin6m0bm2c"))

(define rust-equivalent-1.0.2
  (crate-source "equivalent" "1.0.2"
                "03swzqznragy8n0x31lqc78g2af054jwivp7lkrbrc0khz74lyl7"))

(define rust-err-derive-0.3.1
  (crate-source "err-derive" "0.3.1"
                "17ma9inqvjwklbzsh899cwkqw7113zi7qhqwii4r1vgkimy8hjn3"))

(define rust-filetime-0.2.26
  (crate-source "filetime" "0.2.26"
                "1vb3vz83saxr084wjf2032hspx7wfc5ggggnhc15i9kg3g6ha1dw"))

(define rust-find-msvc-tools-0.1.0
  (crate-source "find-msvc-tools" "0.1.0"
                "0l4nnivhdigxd87drmahqq99qvz7479ad65syq1njwm2m3xy8y71"))

(define rust-flate2-1.1.2
  (crate-source "flate2" "1.1.2"
                "07abz7v50lkdr5fjw8zaw2v8gm2vbppc0f7nqm8x3v3gb6wpsgaa"))

(define rust-fnv-1.0.7
  (crate-source "fnv" "1.0.7"
                "1hc2mcqha06aibcaza94vbi81j6pr9a1bbxrxjfhc91zin8yr7iz"))

(define rust-fsevent-0.4.0
  (crate-source "fsevent" "0.4.0"
                "1djxnc2fmv265xqf1iyfz56smh13v9r1p0w9125wjg6k3fyx3dss"))

(define rust-fsevent-sys-2.0.1
  ;; TODO: Check bundled sources.
  (crate-source "fsevent-sys" "2.0.1"
                "18246vxk7rqn52m0sfrhivxq802i34p2wqqx5zsa0pamjj5086zl"))

(define rust-fuchsia-zircon-0.3.3
  (crate-source "fuchsia-zircon" "0.3.3"
                "10jxc5ks1x06gpd0xg51kcjrxr35nj6qhx2zlc5n7bmskv3675rf"))

(define rust-fuchsia-zircon-sys-0.3.3
  ;; TODO: Check bundled sources.
  (crate-source "fuchsia-zircon-sys" "0.3.3"
                "19zp2085qsyq2bh1gvcxq1lb8w6v6jj9kbdkhpdjrl95fypakjix"))

(define rust-futures-0.3.31
  (crate-source "futures" "0.3.31"
                "0xh8ddbkm9jy8kc5gbvjp9a4b6rqqxvc8471yb2qaz5wm2qhgg35"))

(define rust-futures-channel-0.3.31
  (crate-source "futures-channel" "0.3.31"
                "040vpqpqlbk099razq8lyn74m0f161zd0rp36hciqrwcg2zibzrd"))

(define rust-futures-core-0.3.31
  (crate-source "futures-core" "0.3.31"
                "0gk6yrxgi5ihfanm2y431jadrll00n5ifhnpx090c2f2q1cr1wh5"))

(define rust-futures-executor-0.3.31
  (crate-source "futures-executor" "0.3.31"
                "17vcci6mdfzx4gbk0wx64chr2f13wwwpvyf3xd5fb1gmjzcx2a0y"))

(define rust-futures-io-0.3.31
  (crate-source "futures-io" "0.3.31"
                "1ikmw1yfbgvsychmsihdkwa8a1knank2d9a8dk01mbjar9w1np4y"))

(define rust-futures-sink-0.3.31
  (crate-source "futures-sink" "0.3.31"
                "1xyly6naq6aqm52d5rh236snm08kw8zadydwqz8bip70s6vzlxg5"))

(define rust-futures-task-0.3.31
  (crate-source "futures-task" "0.3.31"
                "124rv4n90f5xwfsm9qw6y99755y021cmi5dhzh253s920z77s3zr"))

(define rust-futures-util-0.3.31
  (crate-source "futures-util" "0.3.31"
                "10aa1ar8bgkgbr4wzxlidkqkcxf77gffyj8j7768h831pcaq784z"))

(define rust-generic-array-0.14.7
  (crate-source "generic-array" "0.14.7"
                "16lyyrzrljfq424c3n8kfwkqihlimmsg5nhshbbp48np3yjrqr45"))

(define rust-getrandom-0.2.16
  (crate-source "getrandom" "0.2.16"
                "14l5aaia20cc6cc08xdlhrzmfcylmrnprwnna20lqf746pqzjprk"))

(define rust-getrandom-0.3.3
  (crate-source "getrandom" "0.3.3"
                "1x6jl875zp6b2b6qp9ghc84b0l76bvng2lvm8zfcmwjl7rb5w516"))

(define rust-gimli-0.31.1
  (crate-source "gimli" "0.31.1"
                "0gvqc0ramx8szv76jhfd4dms0zyamvlg4whhiz11j34hh3dqxqh7"))

(define rust-hashbrown-0.15.5
  (crate-source "hashbrown" "0.15.5"
                "189qaczmjxnikm9db748xyhiw04kpmhm9xj9k9hg0sgx7pjwyacj"))

(define rust-hermit-abi-0.5.2
  (crate-source "hermit-abi" "0.5.2"
                "1744vaqkczpwncfy960j2hxrbjl1q01csm84jpd9dajbdr2yy3zw"))

(define rust-humantime-2.2.0
  (crate-source "humantime" "2.2.0"
                "17rz8jhh1mcv4b03wnknhv1shwq2v9vhkhlfg884pprsig62l4cv"))

(define rust-iana-time-zone-0.1.63
  (crate-source "iana-time-zone" "0.1.63"
                "1n171f5lbc7bryzmp1h30zw86zbvl5480aq02z92lcdwvvjikjdh"))

(define rust-iana-time-zone-haiku-0.1.2
  (crate-source "iana-time-zone-haiku" "0.1.2"
                "17r6jmj31chn7xs9698r122mapq85mfnv98bb4pg6spm0si2f67k"))

(define rust-ident-case-1.0.1
  (crate-source "ident_case" "1.0.1"
                "0fac21q6pwns8gh1hz3nbq15j8fi441ncl6w4vlnd1cmc55kiq5r"))

(define rust-indexmap-2.11.0
  (crate-source "indexmap" "2.11.0"
                "1sb3nmhisf9pdwfcxzqlvx97xifcvlh5g0rqj9j7i7qg8f01jj7j"))

(define rust-inotify-0.7.1
  (crate-source "inotify" "0.7.1"
                "0byhq4x4b2rlbkmfrab5dni39wiq2ls1hv1nhggp7rla5inwc5j8"))

(define rust-inotify-sys-0.1.5
  ;; TODO: Check bundled sources.
  (crate-source "inotify-sys" "0.1.5"
                "1syhjgvkram88my04kv03s0zwa66mdwa5v7ddja3pzwvx2sh4p70"))

(define rust-io-uring-0.7.10
  (crate-source "io-uring" "0.7.10"
                "0yvjyygwdcqjcgw8zp254hvjbm7as1c075dl50spdshas3aa4vq4"))

(define rust-iovec-0.1.4
  (crate-source "iovec" "0.1.4"
                "0ph73qygwx8i0mblrf110cj59l00gkmsgrpzz1rm85syz5pymcxj"))

(define rust-is-terminal-0.4.16
  (crate-source "is-terminal" "0.4.16"
                "1acm63whnpwiw1padm9bpqz04sz8msymrmyxc55mvlq8hqqpykg0"))

(define rust-is-terminal-polyfill-1.70.1
  (crate-source "is_terminal_polyfill" "1.70.1"
                "1kwfgglh91z33kl0w5i338mfpa3zs0hidq5j4ny4rmjwrikchhvr"))

(define rust-itoa-1.0.15
  (crate-source "itoa" "1.0.15"
                "0b4fj9kz54dr3wam0vprjwgygvycyw8r0qwg7vp19ly8b2w16psa"))

(define rust-js-sys-0.3.77
  ;; TODO: Check bundled sources.
  (crate-source "js-sys" "0.3.77"
                "13x2qcky5l22z4xgivi59xhjjx4kxir1zg7gcj0f1ijzd4yg7yhw"))

(define rust-kernel32-sys-0.2.2
  ;; TODO: Check bundled sources.
  (crate-source "kernel32-sys" "0.2.2"
                "1389av0601a9yz8dvx5zha9vmkd6ik7ax0idpb032d28555n41vm"))

(define rust-lazy-static-1.5.0
  (crate-source "lazy_static" "1.5.0"
                "1zk6dqqni0193xg6iijh7i3i44sryglwgvx20spdvwk3r6sbrlmv"))

(define rust-lazycell-1.3.0
  (crate-source "lazycell" "1.3.0"
                "0m8gw7dn30i0zjjpjdyf6pc16c34nl71lpv461mix50x3p70h3c3"))

(define rust-libc-0.2.175
  (crate-source "libc" "0.2.175"
                "0hw5sb3gjr0ivah7s3fmavlpvspjpd4mr009abmam2sr7r4sx0ka"))

(define rust-libredox-0.1.9
  (crate-source "libredox" "0.1.9"
                "1qqczzfqcc3sw3bl7la6qv7i9hy1s7sxhxmdvpxkfgdd3c9904ir"))

(define rust-linked-hash-map-0.5.6
  (crate-source "linked-hash-map" "0.5.6"
                "03vpgw7x507g524nx5i1jf5dl8k3kv0fzg8v3ip6qqwbpkqww5q7"))

(define rust-log-0.4.27
  (crate-source "log" "0.4.27"
                "150x589dqil307rv0rwj0jsgz5bjbwvl83gyl61jf873a7rjvp0k"))

(define rust-md-5-0.10.6
  (crate-source "md-5" "0.10.6"
                "1kvq5rnpm4fzwmyv5nmnxygdhhb2369888a06gdc9pxyrzh7x7nq"))

(define rust-memchr-2.7.5
  (crate-source "memchr" "2.7.5"
                "1h2bh2jajkizz04fh047lpid5wgw2cr9igpkdhl3ibzscpd858ij"))

(define rust-minecraft-protocol-0.1.0.4f93bb3
  rust-minecraft-protocol)

(define rust-minecraft-protocol-derive-0.0.0.4f93bb3
  rust-minecraft-protocol)

(define rust-miniz-oxide-0.8.9
  (crate-source "miniz_oxide" "0.8.9"
                "05k3pdg8bjjzayq3rf0qhpirq9k37pxnasfn4arbs17phqn6m9qz"))

(define rust-mio-0.6.23
  (crate-source "mio" "0.6.23"
                "1i2c1vl8lr45apkh8xbh9k56ihfsmqff5l7s2fya7whvp7sndzaa"))

(define rust-mio-1.0.4
  (crate-source "mio" "1.0.4"
                "073n3kam3nz8j8had35fd2nn7j6a33pi3y5w3kq608cari2d9gkq"))

(define rust-mio-extras-2.0.6
  (crate-source "mio-extras" "2.0.6"
                "069gfhlv0wlwfx1k2sriwfws490kjp490rv2qivyfb01j3i3yh2j"))

(define rust-miow-0.2.2
  (crate-source "miow" "0.2.2"
                "0kcl8rnv0bhiarcdakik670w8fnxzlxhi1ys7152sck68510in7b"))

(define rust-named-binary-tag-0.6.0
  (crate-source "named-binary-tag" "0.6.0"
                "1hyfzq7ncj3h1lzgmcni188ra3jai8mrcfz0lbwm9n9vqvx9hcjj"))

(define rust-net2-0.2.39
  (crate-source "net2" "0.2.39"
                "1b1lxvs192xsvqnszcz7dn4dw3fsvzxnc23qvq39scx26s068fxi"))

(define rust-nix-0.28.0
  (crate-source "nix" "0.28.0"
                "1r0rylax4ycx3iqakwjvaa178jrrwiiwghcw95ndzy72zk25c8db"))

(define rust-notify-4.0.18
  (crate-source "notify" "4.0.18"
                "1lxgy5cx9k785m54aj6w6g13dfk115xj8pln61d8kp55g59d6bdp"))

(define rust-num-traits-0.2.19
  (crate-source "num-traits" "0.2.19"
                "0h984rhdkkqd4ny9cif7y2azl3xdfb7768hb9irhpsch4q3gq787"))

(define rust-object-0.36.7
  (crate-source "object" "0.36.7"
                "11vv97djn9nc5n6w1gc6bd96d2qk2c8cg1kw5km9bsi3v4a8x532"))

(define rust-once-cell-1.21.3
  (crate-source "once_cell" "1.21.3"
                "0b9x77lb9f1j6nqgf5aka4s2qj0nly176bpbrv6f9iakk5ff3xa2"))

(define rust-once-cell-polyfill-1.70.1
  (crate-source "once_cell_polyfill" "1.70.1"
                "1bg0w99srq8h4mkl68l1mza2n2f2hvrg0n8vfa3izjr5nism32d4"))

(define rust-pin-project-lite-0.2.16
  (crate-source "pin-project-lite" "0.2.16"
                "16wzc7z7dfkf9bmjin22f5282783f6mdksnr0nv0j5ym5f9gyg1v"))

(define rust-pin-utils-0.1.0
  (crate-source "pin-utils" "0.1.0"
                "117ir7vslsl2z1a7qzhws4pd01cg2d3338c47swjyvqv2n60v1wb"))

(define rust-ppv-lite86-0.2.21
  (crate-source "ppv-lite86" "0.2.21"
                "1abxx6qz5qnd43br1dd9b2savpihzjza8gb4fbzdql1gxp2f7sl5"))

(define rust-pretty-env-logger-0.5.0
  (crate-source "pretty_env_logger" "0.5.0"
                "076w9dnvcpx6d3mdbkqad8nwnsynb7c8haxmscyrz7g3vga28mw6"))

(define rust-proc-macro-error-1.0.4
  (crate-source "proc-macro-error" "1.0.4"
                "1373bhxaf0pagd8zkyd03kkx6bchzf6g0dkwrwzsnal9z47lj9fs"))

(define rust-proc-macro-error-attr-1.0.4
  (crate-source "proc-macro-error-attr" "1.0.4"
                "0sgq6m5jfmasmwwy8x4mjygx5l7kp8s4j60bv25ckv2j1qc41gm1"))

(define rust-proc-macro2-1.0.101
  (crate-source "proc-macro2" "1.0.101"
                "1pijhychkpl7rcyf1h7mfk6gjfii1ywf5n0snmnqs5g4hvyl7bl9"))

(define rust-proxy-protocol-0.5.0
  (crate-source "proxy-protocol" "0.5.0"
                "0cnmf4kcw6yl1si9v78gs9ybyc7f19j37k2hyg2zaf6744ncfl0f"))

(define rust-quartz-nbt-0.2.9
  (crate-source "quartz_nbt" "0.2.9"
                "08cqyjsnxn5racklwkyhabfqk375cid9bdwqv33dknm2kcr8kwys"))

(define rust-quartz-nbt-macros-0.1.1
  (crate-source "quartz_nbt_macros" "0.1.1"
                "1vfsx0bggm6s7qmif61higs9l3lyqbwafa755l6q87sdi86am6r8"))

(define rust-quote-1.0.40
  (crate-source "quote" "1.0.40"
                "1394cxjg6nwld82pzp2d4fp6pmaz32gai1zh9z5hvh0dawww118q"))

(define rust-r-efi-5.3.0
  (crate-source "r-efi" "5.3.0"
                "03sbfm3g7myvzyylff6qaxk4z6fy76yv860yy66jiswc2m6b7kb9"))

(define rust-rand-0.8.5
  (crate-source "rand" "0.8.5"
                "013l6931nn7gkc23jz5mm3qdhf93jjf0fg64nz2lp4i51qd8vbrl"))

(define rust-rand-chacha-0.3.1
  (crate-source "rand_chacha" "0.3.1"
                "123x2adin558xbhvqb8w4f6syjsdkmqff8cxwhmjacpsl1ihmhg6"))

(define rust-rand-core-0.6.4
  (crate-source "rand_core" "0.6.4"
                "0b4j2v4cb5krak1pv6kakv4sz6xcwbrmy2zckc32hsigbrwy82zc"))

(define rust-rcon-0.6.0
  (crate-source "rcon" "0.6.0"
                "0ys18zr00ydgz73xlzk3xg0migil4kczc9xg9dpps7h43ksap2v1"))

(define rust-redox-syscall-0.5.17
  (crate-source "redox_syscall" "0.5.17"
                "0xrvpchkaxph3r5ww2i04v9nwg3843fp3prf8kqlh1gv01b4c1sl"))

(define rust-regex-1.11.2
  (crate-source "regex" "1.11.2"
                "04k9rzxd11hcahpyihlswy6f1zqw7lspirv4imm4h0lcdl8gvmr3"))

(define rust-regex-automata-0.4.10
  (crate-source "regex-automata" "0.4.10"
                "1mllcfmgjcl6d52d5k09lwwq9wj5mwxccix4bhmw5spy1gx5i53b"))

(define rust-regex-syntax-0.8.6
  (crate-source "regex-syntax" "0.8.6"
                "00chjpglclfskmc919fj5aq308ffbrmcn7kzbkz92k231xdsmx6a"))

(define rust-rustc-demangle-0.1.26
  (crate-source "rustc-demangle" "0.1.26"
                "1kja3nb0yhlm4j2p1hl8d7sjmn2g9fa1s4pj0qma5kj2lcndkxsn"))

(define rust-rustversion-1.0.22
  (crate-source "rustversion" "1.0.22"
                "0vfl70jhv72scd9rfqgr2n11m5i9l1acnk684m2w83w0zbqdx75k"))

(define rust-ryu-1.0.20
  (crate-source "ryu" "1.0.20"
                "07s855l8sb333h6bpn24pka5sp7hjk2w667xy6a0khkf6sqv5lr8"))

(define rust-same-file-1.0.6
  (crate-source "same-file" "1.0.6"
                "00h5j1w87dmhnvbv9l8bic3y7xxsnjmssvifw2ayvgx9mb1ivz4k"))

(define rust-serde-1.0.219
  (crate-source "serde" "1.0.219"
                "1dl6nyxnsi82a197sd752128a4avm6mxnscywas1jq30srp2q3jz"))

(define rust-serde-derive-1.0.219
  (crate-source "serde_derive" "1.0.219"
                "001azhjmj7ya52pmfiw4ppxm16nd44y15j2pf5gkcwrcgz7pc0jv"))

(define rust-serde-json-1.0.143
  (crate-source "serde_json" "1.0.143"
                "0njabwzldvj13ykrf1aaf4gh5cgl25kf9hzbpafbv3qh3ppsn0fl"))

(define rust-serde-spanned-0.6.9
  (crate-source "serde_spanned" "0.6.9"
                "18vmxq6qfrm110caszxrzibjhy2s54n1g5w1bshxq9kjmz7y0hdz"))

(define rust-shlex-1.3.0
  (crate-source "shlex" "1.3.0"
                "0r1y6bv26c1scpxvhg2cabimrmwgbp4p3wy6syj9n0c4s3q2znhg"))

(define rust-signal-hook-registry-1.4.6
  (crate-source "signal-hook-registry" "1.4.6"
                "12y2v1ms5z111fymaw1v8k93m5chnkp21h0jknrydkj8zydp395j"))

(define rust-slab-0.4.11
  (crate-source "slab" "0.4.11"
                "12bm4s88rblq02jjbi1dw31984w61y2ldn13ifk5gsqgy97f8aks"))

(define rust-snafu-0.6.10
  (crate-source "snafu" "0.6.10"
                "19wwqxwb85pl040qk5xylj0vlznib3xzy9hcv2q0h8qv4qy2vcga"))

(define rust-snafu-derive-0.6.10
  (crate-source "snafu-derive" "0.6.10"
                "0nri7ma06g5kimpcdcm8359a55nmps5f3kcngy0j6bin7jhfy20m"))

(define rust-socket2-0.6.0
  (crate-source "socket2" "0.6.0"
                "01qqdzfnr0bvdwq6wl56c9c4m2cvbxn43dfpcv8gjx208sph8d93"))

(define rust-strsim-0.11.1
  (crate-source "strsim" "0.11.1"
                "0kzvqlw8hxqb7y598w1s0hxlnmi84sg5vsipp3yg5na5d1rvba3x"))

(define rust-syn-1.0.109
  (crate-source "syn" "1.0.109"
                "0ds2if4600bd59wsv7jjgfkayfzy3hnazs394kz6zdkmna8l3dkj"))

(define rust-syn-2.0.106
  (crate-source "syn" "2.0.106"
                "19mddxp1ia00hfdzimygqmr1jqdvyl86k48427bkci4d08wc9rzd"))

(define rust-synstructure-0.12.6
  (crate-source "synstructure" "0.12.6"
                "03r1lydbf3japnlpc4wka7y90pmz1i0danaj3f9a7b431akdlszk"))

(define rust-termcolor-1.4.1
  (crate-source "termcolor" "1.4.1"
                "0mappjh3fj3p2nmrg4y7qv94rchwi9mzmgmfflr8p2awdj7lyy86"))

(define rust-thiserror-1.0.69
  (crate-source "thiserror" "1.0.69"
                "0lizjay08agcr5hs9yfzzj6axs53a2rgx070a1dsi3jpkcrzbamn"))

(define rust-thiserror-impl-1.0.69
  (crate-source "thiserror-impl" "1.0.69"
                "1h84fmn2nai41cxbhk6pqf46bxqq1b344v8yz089w1chzi76rvjg"))

(define rust-tokio-1.47.1
  (crate-source "tokio" "1.47.1"
                "0f2hp5v3payg6x04ijj67si1wsdhksskhmjs2k9p5f7bmpyrmr49"))

(define rust-tokio-macros-2.5.0
  (crate-source "tokio-macros" "2.5.0"
                "1f6az2xbvqp7am417b78d1za8axbvjvxnmkakz9vr8s52czx81kf"))

(define rust-toml-0.8.23
  (crate-source "toml" "0.8.23"
                "0qnkrq4lm2sdhp3l6cb6f26i8zbnhqb7mhbmksd550wxdfcyn6yw"))

(define rust-toml-datetime-0.6.11
  (crate-source "toml_datetime" "0.6.11"
                "077ix2hb1dcya49hmi1avalwbixmrs75zgzb3b2i7g2gizwdmk92"))

(define rust-toml-edit-0.22.27
  (crate-source "toml_edit" "0.22.27"
                "16l15xm40404asih8vyjvnka9g0xs9i4hfb6ry3ph9g419k8rzj1"))

(define rust-toml-write-0.1.2
  (crate-source "toml_write" "0.1.2"
                "008qlhqlqvljp1gpp9rn5cqs74gwvdgbvs92wnpq8y3jlz4zi6ax"))

(define rust-typenum-1.18.0
  (crate-source "typenum" "1.18.0"
                "0gwgz8n91pv40gabrr1lzji0b0hsmg0817njpy397bq7rvizzk0x"))

(define rust-unicase-2.8.1
  (crate-source "unicase" "2.8.1"
                "0fd5ddbhpva7wrln2iah054ar2pc1drqjcll0f493vj3fv8l9f3m"))

(define rust-unicode-ident-1.0.18
  (crate-source "unicode-ident" "1.0.18"
                "04k5r6sijkafzljykdq26mhjpmhdx4jwzvn1lh90g9ax9903jpss"))

(define rust-unicode-width-0.2.1
  (crate-source "unicode-width" "0.2.1"
                "0k0mlq7xy1y1kq6cgv1r2rs2knn6rln3g3af50rhi0dkgp60f6ja"))

(define rust-unicode-xid-0.2.6
  (crate-source "unicode-xid" "0.2.6"
                "0lzqaky89fq0bcrh6jj6bhlz37scfd8c7dsj5dq7y32if56c1hgb"))

(define rust-utf8parse-0.2.2
  (crate-source "utf8parse" "0.2.2"
                "088807qwjq46azicqwbhlmzwrbkz7l4hpw43sdkdyyk524vdxaq6"))

(define rust-uuid-1.18.0
  (crate-source "uuid" "1.18.0"
                "1gn1vlggiwrdpizqcpc5hyxsqz9s5215bbay1b182mqn7rj9ccgk"))

(define rust-version-check-0.9.5
  (crate-source "version_check" "0.9.5"
                "0nhhi4i5x89gm911azqbn7avs9mdacw2i3vcz3cnmz3mv4rqz4hb"))

(define rust-version-compare-0.2.0
  (crate-source "version-compare" "0.2.0"
                "12y9262fhjm1wp0aj3mwhads7kv0jz8h168nn5fb8b43nwf9abl5"))

(define rust-walkdir-2.5.0
  (crate-source "walkdir" "2.5.0"
                "0jsy7a710qv8gld5957ybrnc07gavppp963gs32xk4ag8130jy99"))

(define rust-wasi-0.11.1+wasi-snapshot-preview1
  (crate-source "wasi" "0.11.1+wasi-snapshot-preview1"
                "0jx49r7nbkbhyfrfyhz0bm4817yrnxgd3jiwwwfv0zl439jyrwyc"))

(define rust-wasi-0.14.3+wasi-0.2.4
  (crate-source "wasi" "0.14.3+wasi-0.2.4"
                "158c0cy561zlncw71hjh1pficw60p1nj7ki8kqm2gpbv0f1swlba"))

(define rust-wasm-bindgen-0.2.100
  (crate-source "wasm-bindgen" "0.2.100"
                "1x8ymcm6yi3i1rwj78myl1agqv2m86i648myy3lc97s9swlqkp0y"))

(define rust-wasm-bindgen-backend-0.2.100
  (crate-source "wasm-bindgen-backend" "0.2.100"
                "1ihbf1hq3y81c4md9lyh6lcwbx6a5j0fw4fygd423g62lm8hc2ig"))

(define rust-wasm-bindgen-macro-0.2.100
  (crate-source "wasm-bindgen-macro" "0.2.100"
                "01xls2dvzh38yj17jgrbiib1d3nyad7k2yw9s0mpklwys333zrkz"))

(define rust-wasm-bindgen-macro-support-0.2.100
  (crate-source "wasm-bindgen-macro-support" "0.2.100"
                "1plm8dh20jg2id0320pbmrlsv6cazfv6b6907z19ys4z1jj7xs4a"))

(define rust-wasm-bindgen-shared-0.2.100
  (crate-source "wasm-bindgen-shared" "0.2.100"
                "0gffxvqgbh9r9xl36gprkfnh3w9gl8wgia6xrin7v11sjcxxf18s"))

(define rust-winapi-0.2.8
  (crate-source "winapi" "0.2.8"
                "0yh816lh6lf56dpsgxy189c2ai1z3j8mw9si6izqb6wsjkbcjz8n"))

(define rust-winapi-0.3.9
  (crate-source "winapi" "0.3.9"
                "06gl025x418lchw1wxj64ycr7gha83m44cjr5sarhynd9xkrm0sw"))

(define rust-winapi-build-0.1.1
  (crate-source "winapi-build" "0.1.1"
                "1g4rqsgjky0a7530qajn2bbfcrl2v0zb39idgdws9b1l7gp5wc9d"))

(define rust-winapi-i686-pc-windows-gnu-0.4.0
  (crate-source "winapi-i686-pc-windows-gnu" "0.4.0"
                "1dmpa6mvcvzz16zg6d5vrfy4bxgg541wxrcip7cnshi06v38ffxc"))

(define rust-winapi-util-0.1.10
  (crate-source "winapi-util" "0.1.10"
                "08hb8rj3aq9lcrfmliqs4l7v9zh6srbcn0376yn0pndkf5qvyy09"))

(define rust-winapi-x86-64-pc-windows-gnu-0.4.0
  (crate-source "winapi-x86_64-pc-windows-gnu" "0.4.0"
                "0gqq64czqb64kskjryj8isp62m2sgvx25yyj3kpc2myh85w24bki"))

(define rust-windows-aarch64-gnullvm-0.52.6
  (crate-source "windows_aarch64_gnullvm" "0.52.6"
                "1lrcq38cr2arvmz19v32qaggvj8bh1640mdm9c2fr877h0hn591j"))

(define rust-windows-aarch64-gnullvm-0.53.0
  (crate-source "windows_aarch64_gnullvm" "0.53.0"
                "0r77pbpbcf8bq4yfwpz2hpq3vns8m0yacpvs2i5cn6fx1pwxbf46"))

(define rust-windows-aarch64-msvc-0.52.6
  (crate-source "windows_aarch64_msvc" "0.52.6"
                "0sfl0nysnz32yyfh773hpi49b1q700ah6y7sacmjbqjjn5xjmv09"))

(define rust-windows-aarch64-msvc-0.53.0
  (crate-source "windows_aarch64_msvc" "0.53.0"
                "0v766yqw51pzxxwp203yqy39ijgjamp54hhdbsyqq6x1c8gilrf7"))

(define rust-windows-core-0.61.2
  (crate-source "windows-core" "0.61.2"
                "1qsa3iw14wk4ngfl7ipcvdf9xyq456ms7cx2i9iwf406p7fx7zf0"))

(define rust-windows-i686-gnu-0.52.6
  (crate-source "windows_i686_gnu" "0.52.6"
                "02zspglbykh1jh9pi7gn8g1f97jh1rrccni9ivmrfbl0mgamm6wf"))

(define rust-windows-i686-gnu-0.53.0
  (crate-source "windows_i686_gnu" "0.53.0"
                "1hvjc8nv95sx5vdd79fivn8bpm7i517dqyf4yvsqgwrmkmjngp61"))

(define rust-windows-i686-gnullvm-0.52.6
  (crate-source "windows_i686_gnullvm" "0.52.6"
                "0rpdx1537mw6slcpqa0rm3qixmsb79nbhqy5fsm3q2q9ik9m5vhf"))

(define rust-windows-i686-gnullvm-0.53.0
  (crate-source "windows_i686_gnullvm" "0.53.0"
                "04df1in2k91qyf1wzizvh560bvyzq20yf68k8xa66vdzxnywrrlw"))

(define rust-windows-i686-msvc-0.52.6
  (crate-source "windows_i686_msvc" "0.52.6"
                "0rkcqmp4zzmfvrrrx01260q3xkpzi6fzi2x2pgdcdry50ny4h294"))

(define rust-windows-i686-msvc-0.53.0
  (crate-source "windows_i686_msvc" "0.53.0"
                "0pcvb25fkvqnp91z25qr5x61wyya12lx8p7nsa137cbb82ayw7sq"))

(define rust-windows-implement-0.60.0
  (crate-source "windows-implement" "0.60.0"
                "0dm88k3hlaax85xkls4gf597ar4z8m5vzjjagzk910ph7b8xszx4"))

(define rust-windows-interface-0.59.1
  (crate-source "windows-interface" "0.59.1"
                "1a4zr8740gyzzhq02xgl6vx8l669jwfby57xgf0zmkcdkyv134mx"))

(define rust-windows-link-0.1.3
  (crate-source "windows-link" "0.1.3"
                "12kr1p46dbhpijr4zbwr2spfgq8i8c5x55mvvfmyl96m01cx4sjy"))

(define rust-windows-result-0.3.4
  (crate-source "windows-result" "0.3.4"
                "1il60l6idrc6hqsij0cal0mgva6n3w6gq4ziban8wv6c6b9jpx2n"))

(define rust-windows-strings-0.4.2
  (crate-source "windows-strings" "0.4.2"
                "0mrv3plibkla4v5kaakc2rfksdd0b14plcmidhbkcfqc78zwkrjn"))

(define rust-windows-sys-0.59.0
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.59.0"
                "0fw5672ziw8b3zpmnbp9pdv1famk74f1l9fcbc3zsrzdg56vqf0y"))

(define rust-windows-sys-0.60.2
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.60.2"
                "1jrbc615ihqnhjhxplr2kw7rasrskv9wj3lr80hgfd42sbj01xgj"))

(define rust-windows-targets-0.52.6
  (crate-source "windows-targets" "0.52.6"
                "0wwrx625nwlfp7k93r2rra568gad1mwd888h1jwnl0vfg5r4ywlv"))

(define rust-windows-targets-0.53.3
  (crate-source "windows-targets" "0.53.3"
                "14fwwm136dhs3i1impqrrip7nvkra3bdxa4nqkblj604qhqn1znm"))

(define rust-windows-x86-64-gnu-0.52.6
  (crate-source "windows_x86_64_gnu" "0.52.6"
                "0y0sifqcb56a56mvn7xjgs8g43p33mfqkd8wj1yhrgxzma05qyhl"))

(define rust-windows-x86-64-gnu-0.53.0
  (crate-source "windows_x86_64_gnu" "0.53.0"
                "1flh84xkssn1n6m1riddipydcksp2pdl45vdf70jygx3ksnbam9f"))

(define rust-windows-x86-64-gnullvm-0.52.6
  (crate-source "windows_x86_64_gnullvm" "0.52.6"
                "03gda7zjx1qh8k9nnlgb7m3w3s1xkysg55hkd1wjch8pqhyv5m94"))

(define rust-windows-x86-64-gnullvm-0.53.0
  (crate-source "windows_x86_64_gnullvm" "0.53.0"
                "0mvc8119xpbi3q2m6mrjcdzl6afx4wffacp13v76g4jrs1fh6vha"))

(define rust-windows-x86-64-msvc-0.52.6
  (crate-source "windows_x86_64_msvc" "0.52.6"
                "1v7rb5cibyzx8vak29pdrk8nx9hycsjs4w0jgms08qk49jl6v7sq"))

(define rust-windows-x86-64-msvc-0.53.0
  (crate-source "windows_x86_64_msvc" "0.53.0"
                "11h4i28hq0zlnjcaqi2xdxr7ibnpa8djfggch9rki1zzb8qi8517"))

(define rust-winnow-0.7.13
  (crate-source "winnow" "0.7.13"
                "1krrjc1wj2vx0r57m9nwnlc1zrhga3fq41d8w9hysvvqb5mj7811"))

(define rust-wit-bindgen-0.45.0
  (crate-source "wit-bindgen" "0.45.0"
                "053q28k1hn9qgm0l05gr9751d8q34zcz6lbzviwxiqxs3n1q68h5"))

(define rust-ws2-32-sys-0.2.1
  ;; TODO: Check bundled sources.
  (crate-source "ws2_32-sys" "0.2.1"
                "0ppscg5qfqaw0gzwv2a4nhn5bn01ff9iwn6ysqnzm4n8s3myz76m"))

(define rust-zerocopy-0.8.26
  (crate-source "zerocopy" "0.8.26"
                "0bvsj0qzq26zc6nlrm3z10ihvjspyngs7n0jw1fz031i7h6xsf8h"))

(define rust-zerocopy-derive-0.8.26
  (crate-source "zerocopy-derive" "0.8.26"
                "10aiywi5qkha0mpsnb1zjwi44wl2rhdncaf3ykbp4i9nqm65pkwy"))

(define ssss-separator 'end-of-crates)


;;;
;;; Cargo inputs.
;;;

(define-cargo-inputs lookup-cargo-inputs
                     (lazymc =>
                             (list rust-addr2line-0.24.2
                              rust-adler2-2.0.1
                              rust-aho-corasick-1.1.3
                              rust-android-tzdata-0.1.1
                              rust-android-system-properties-0.1.5
                              rust-anstream-0.6.20
                              rust-anstyle-1.0.11
                              rust-anstyle-parse-0.2.7
                              rust-anstyle-query-1.1.4
                              rust-anstyle-wincon-3.0.10
                              rust-anyhow-1.0.99
                              rust-autocfg-1.5.0
                              rust-backtrace-0.3.75
                              rust-base64-0.22.1
                              rust-bitflags-1.3.2
                              rust-bitflags-2.9.3
                              rust-block-buffer-0.10.4
                              rust-bumpalo-3.19.0
                              rust-byteorder-1.5.0
                              rust-bytes-1.10.1
                              rust-cc-1.2.35
                              rust-cesu8-1.1.0
                              rust-cfg-if-0.1.10
                              rust-cfg-if-1.0.3
                              rust-cfg-aliases-0.1.1
                              rust-chrono-0.4.41
                              rust-clap-4.5.46
                              rust-clap-builder-4.5.46
                              rust-clap-lex-0.7.5
                              rust-colorchoice-1.0.4
                              rust-colored-2.2.0
                              rust-core-foundation-sys-0.8.7
                              rust-crc32fast-1.5.0
                              rust-crypto-common-0.1.6
                              rust-darling-0.20.11
                              rust-darling-core-0.20.11
                              rust-darling-macro-0.20.11
                              rust-derive-builder-0.20.2
                              rust-derive-builder-core-0.20.2
                              rust-derive-builder-macro-0.20.2
                              rust-digest-0.10.7
                              rust-doc-comment-0.3.3
                              rust-dotenv-0.15.0
                              rust-env-logger-0.10.2
                              rust-equivalent-1.0.2
                              rust-err-derive-0.3.1
                              rust-filetime-0.2.26
                              rust-find-msvc-tools-0.1.0
                              rust-flate2-1.1.2
                              rust-fnv-1.0.7
                              rust-fsevent-0.4.0
                              rust-fsevent-sys-2.0.1
                              rust-fuchsia-zircon-0.3.3
                              rust-fuchsia-zircon-sys-0.3.3
                              rust-futures-0.3.31
                              rust-futures-channel-0.3.31
                              rust-futures-core-0.3.31
                              rust-futures-executor-0.3.31
                              rust-futures-io-0.3.31
                              rust-futures-sink-0.3.31
                              rust-futures-task-0.3.31
                              rust-futures-util-0.3.31
                              rust-generic-array-0.14.7
                              rust-getrandom-0.2.16
                              rust-getrandom-0.3.3
                              rust-gimli-0.31.1
                              rust-hashbrown-0.15.5
                              rust-hermit-abi-0.5.2
                              rust-humantime-2.2.0
                              rust-iana-time-zone-0.1.63
                              rust-iana-time-zone-haiku-0.1.2
                              rust-ident-case-1.0.1
                              rust-indexmap-2.11.0
                              rust-inotify-0.7.1
                              rust-inotify-sys-0.1.5
                              rust-io-uring-0.7.10
                              rust-iovec-0.1.4
                              rust-is-terminal-0.4.16
                              rust-is-terminal-polyfill-1.70.1
                              rust-itoa-1.0.15
                              rust-js-sys-0.3.77
                              rust-kernel32-sys-0.2.2
                              rust-lazy-static-1.5.0
                              rust-lazycell-1.3.0
                              rust-libc-0.2.175
                              rust-libredox-0.1.9
                              rust-linked-hash-map-0.5.6
                              rust-log-0.4.27
                              rust-md-5-0.10.6
                              rust-memchr-2.7.5
                              rust-minecraft-protocol-0.1.0.4f93bb3
                              rust-minecraft-protocol-derive-0.0.0.4f93bb3
                              rust-miniz-oxide-0.8.9
                              rust-mio-0.6.23
                              rust-mio-1.0.4
                              rust-mio-extras-2.0.6
                              rust-miow-0.2.2
                              rust-named-binary-tag-0.6.0
                              rust-net2-0.2.39
                              rust-nix-0.28.0
                              rust-notify-4.0.18
                              rust-num-traits-0.2.19
                              rust-object-0.36.7
                              rust-once-cell-1.21.3
                              rust-once-cell-polyfill-1.70.1
                              rust-pin-project-lite-0.2.16
                              rust-pin-utils-0.1.0
                              rust-ppv-lite86-0.2.21
                              rust-pretty-env-logger-0.5.0
                              rust-proc-macro-error-1.0.4
                              rust-proc-macro-error-attr-1.0.4
                              rust-proc-macro2-1.0.101
                              rust-proxy-protocol-0.5.0
                              rust-quartz-nbt-0.2.9
                              rust-quartz-nbt-macros-0.1.1
                              rust-quote-1.0.40
                              rust-r-efi-5.3.0
                              rust-rand-0.8.5
                              rust-rand-chacha-0.3.1
                              rust-rand-core-0.6.4
                              rust-rcon-0.6.0
                              rust-redox-syscall-0.5.17
                              rust-regex-1.11.2
                              rust-regex-automata-0.4.10
                              rust-regex-syntax-0.8.6
                              rust-rustc-demangle-0.1.26
                              rust-rustversion-1.0.22
                              rust-ryu-1.0.20
                              rust-same-file-1.0.6
                              rust-serde-1.0.219
                              rust-serde-derive-1.0.219
                              rust-serde-json-1.0.143
                              rust-serde-spanned-0.6.9
                              rust-shlex-1.3.0
                              rust-signal-hook-registry-1.4.6
                              rust-slab-0.4.11
                              rust-snafu-0.6.10
                              rust-snafu-derive-0.6.10
                              rust-socket2-0.6.0
                              rust-strsim-0.11.1
                              rust-syn-1.0.109
                              rust-syn-2.0.106
                              rust-synstructure-0.12.6
                              rust-termcolor-1.4.1
                              rust-thiserror-1.0.69
                              rust-thiserror-impl-1.0.69
                              rust-tokio-1.47.1
                              rust-tokio-macros-2.5.0
                              rust-toml-0.8.23
                              rust-toml-datetime-0.6.11
                              rust-toml-edit-0.22.27
                              rust-toml-write-0.1.2
                              rust-typenum-1.18.0
                              rust-unicase-2.8.1
                              rust-unicode-ident-1.0.18
                              rust-unicode-width-0.2.1
                              rust-unicode-xid-0.2.6
                              rust-utf8parse-0.2.2
                              rust-uuid-1.18.0
                              rust-version-compare-0.2.0
                              rust-version-check-0.9.5
                              rust-walkdir-2.5.0
                              rust-wasi-0.11.1+wasi-snapshot-preview1
                              rust-wasi-0.14.3+wasi-0.2.4
                              rust-wasm-bindgen-0.2.100
                              rust-wasm-bindgen-backend-0.2.100
                              rust-wasm-bindgen-macro-0.2.100
                              rust-wasm-bindgen-macro-support-0.2.100
                              rust-wasm-bindgen-shared-0.2.100
                              rust-winapi-0.2.8
                              rust-winapi-0.3.9
                              rust-winapi-build-0.1.1
                              rust-winapi-i686-pc-windows-gnu-0.4.0
                              rust-winapi-util-0.1.10
                              rust-winapi-x86-64-pc-windows-gnu-0.4.0
                              rust-windows-core-0.61.2
                              rust-windows-implement-0.60.0
                              rust-windows-interface-0.59.1
                              rust-windows-link-0.1.3
                              rust-windows-result-0.3.4
                              rust-windows-strings-0.4.2
                              rust-windows-sys-0.59.0
                              rust-windows-sys-0.60.2
                              rust-windows-targets-0.52.6
                              rust-windows-targets-0.53.3
                              rust-windows-aarch64-gnullvm-0.52.6
                              rust-windows-aarch64-gnullvm-0.53.0
                              rust-windows-aarch64-msvc-0.52.6
                              rust-windows-aarch64-msvc-0.53.0
                              rust-windows-i686-gnu-0.52.6
                              rust-windows-i686-gnu-0.53.0
                              rust-windows-i686-gnullvm-0.52.6
                              rust-windows-i686-gnullvm-0.53.0
                              rust-windows-i686-msvc-0.52.6
                              rust-windows-i686-msvc-0.53.0
                              rust-windows-x86-64-gnu-0.52.6
                              rust-windows-x86-64-gnu-0.53.0
                              rust-windows-x86-64-gnullvm-0.52.6
                              rust-windows-x86-64-gnullvm-0.53.0
                              rust-windows-x86-64-msvc-0.52.6
                              rust-windows-x86-64-msvc-0.53.0
                              rust-winnow-0.7.13
                              rust-wit-bindgen-0.45.0
                              rust-ws2-32-sys-0.2.1
                              rust-zerocopy-0.8.26
                              rust-zerocopy-derive-0.8.26))
                     (protocol =>
                               (list rust-adler2-2.0.1
                                     rust-bumpalo-3.19.0
                                     rust-byteorder-1.5.0
                                     rust-cfg-if-1.0.3
                                     rust-crc32fast-1.5.0
                                     rust-flate2-1.1.2
                                     rust-getrandom-0.3.3
                                     rust-itoa-1.0.15
                                     rust-js-sys-0.3.77
                                     rust-libc-0.2.175
                                     rust-linked-hash-map-0.5.6
                                     rust-log-0.4.27
                                     rust-memchr-2.7.5
                                     rust-miniz-oxide-0.8.9
                                     rust-named-binary-tag-0.6.0
                                     rust-once-cell-1.21.3
                                     rust-proc-macro2-1.0.101
                                     rust-quote-1.0.40
                                     rust-r-efi-5.3.0
                                     rust-rustversion-1.0.22
                                     rust-ryu-1.0.20
                                     rust-serde-1.0.219
                                     rust-serde-derive-1.0.219
                                     rust-serde-json-1.0.143
                                     rust-syn-1.0.109
                                     rust-syn-2.0.106
                                     rust-unicode-ident-1.0.18
                                     rust-uuid-1.18.0
                                     rust-wasi-0.14.3+wasi-0.2.4
                                     rust-wasm-bindgen-0.2.100
                                     rust-wasm-bindgen-backend-0.2.100
                                     rust-wasm-bindgen-macro-0.2.100
                                     rust-wasm-bindgen-macro-support-0.2.100
                                     rust-wasm-bindgen-shared-0.2.100
                                     rust-wit-bindgen-0.45.0))
                     (protocol-define =>
                                      (list rust-adler2-2.0.1
                                       rust-bumpalo-3.19.0
                                       rust-byteorder-1.5.0
                                       rust-cfg-if-1.0.3
                                       rust-crc32fast-1.5.0
                                       rust-flate2-1.1.2
                                       rust-getrandom-0.3.3
                                       rust-itoa-1.0.15
                                       rust-js-sys-0.3.77
                                       rust-libc-0.2.175
                                       rust-linked-hash-map-0.5.6
                                       rust-log-0.4.27
                                       rust-memchr-2.7.5
                                       rust-miniz-oxide-0.8.9
                                       rust-named-binary-tag-0.6.0
                                       rust-once-cell-1.21.3
                                       rust-proc-macro2-1.0.101
                                       rust-quote-1.0.40
                                       rust-r-efi-5.3.0
                                       rust-rustversion-1.0.22
                                       rust-ryu-1.0.20
                                       rust-serde-1.0.219
                                       rust-serde-derive-1.0.219
                                       rust-serde-json-1.0.143
                                       rust-syn-1.0.109
                                       rust-syn-2.0.106
                                       rust-unicode-ident-1.0.18
                                       rust-uuid-1.18.0
                                       rust-wasi-0.14.3+wasi-0.2.4
                                       rust-wasm-bindgen-0.2.100
                                       rust-wasm-bindgen-backend-0.2.100
                                       rust-wasm-bindgen-macro-0.2.100
                                       rust-wasm-bindgen-macro-support-0.2.100
                                       rust-wasm-bindgen-shared-0.2.100
                                       rust-wit-bindgen-0.45.0)))
