<!-- File: perf_sd_mx6ul.md
     Author: Daniel Selvan, Jasmin Infotech
-->

# To be updated for i.<d/>MX 6SX Sabre SD EVK

- boot medium: SD Card
- class - 10
- size - 16 GB

The tests are performed by [disk_benchmark.sh](recipes-support/sys-setup/files/disk_benchmark.sh) script for 100MB data. The chunk size can be specified by modifying the script.

**NOTE**:

1. For writing the source is `/dev/zero` to avoid data bottleneck. Hence the real world performance may decrease slightly with the source read speed.
2. For reading the destination is se to `/dev/null` again to eliminate the writing bottleneck.

---

## Plain block readings

as a base line (1MB blocks)

| S.<d/>No | Write (MB/s) | Read (MB/s) |
| -------- | ------------ | ----------- |
| 1        | 21.2         | 23.0        |
| 2        | 24.3         | 23.0        |
| 3        | 29.4         | 22.7        |
| 4        | 22.4         | 23.0        |
| 5        | 26.6         | 23.0        |

- table readings are top 5 on 10 iterations

---

## Which `cipher:hash` combination?

**`AES` in `CBC` mode with `SHA256` for hashing** is chosen as the algorithm of choice for this experiment as this has the direct `CAAM` implementation.

- cipher - aes-cbc-essiv:sha256
- keysize - 256 bits

```log
root@imx6ulevk:~# cat /proc/crypto
name         : echainiv(authenc(hmac(sha256),cbc(aes)))
driver       : echainiv-authenc-hmac-sha256-cbc-aes-caam
module       : kernel
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : yes
blocksize    : 16
ivsize       : 16
maxauthsize  : 32
geniv        : <none>

root@imx6ulevk:~# cryptsetup luksDump /dev/mmcblk1p3
LUKS header information
Version:        2
Epoch:          5
Metadata area:  16384 [bytes]
Keyslots area:  16744448 [bytes]
UUID:           ad554c0b-9f1f-401b-b58d-a04e67cfe5b2
Label:          (no label)
Subsystem:      (no subsystem)
Flags:          (no flags)

Data segments:
  0: crypt
        offset: 16777216 [bytes]
        length: (whole device)
        cipher: aes-cbc-essiv:sha256
        sector: 512 [bytes]

Keyslots:
  1: luks2
        Key:        256 bits
        Priority:   normal
        Cipher:     aes-cbc-essiv:sha256
        Cipher key: 256 bits
        PBKDF:      argon2i
        Time cost:  4
        Memory:     11091
        Threads:    1
        Salt:       36 af 62 a6 6b da 4a 6c 85 d3 86 17 b6 14 ff e5
                    83 d7 bb 4b cd 89 95 a0 25 e6 4a e7 ed 1d 5f 3b
        AF stripes: 4000
        AF hash:    sha256
```

**NOTE**: AES in XTS is the most convenient cipher for block-oriented storage devices and shows significant performance gain, however, this mode is not _natively_ supported on i.<d/>MX’s CAAM module.

## With CAAM Acceleration

DM-Crypt performs cryptographic operations via the interfaces provided by the Linux kernel crypto API. The kernel crypto API defines a standard, extensible interface to ciphers and other data transformations implemented in the kernel (or as loadable modules).

DM-Crypt parses the cipher specification `aes-cbc-essiv:sha256` passed as part of its mapping table and instantiates the corresponding transforms via the kernel crypto API.

Run `cryptsetup benchmark` to get a speed comparison of different choices. The following shows the comparison between `AES-XTS` and `AES-CBC` for `256 bytes` key length.

```log
root@imx6ulevk:~# cat /proc/crypto
name         : cbc(aes)
driver       : cbc-aes-caam
module       : kernel
priority     : 3000
refcnt       : 3
selftest     : passed
internal     : no
type         : givcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <built-in>

name         : xts(aes)
driver       : xts(ecb-aes-caam)
module       : kernel
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
chunksize    : 16
walksize     : 16

root@imx6ulevk:~# cryptsetup benchmark
# Tests are approximate using memory only (no storage IO).
#     Algorithm |       Key |      Encryption |      Decryption
        aes-cbc        256b        24.4 MiB/s        23.6 MiB/s
        aes-xts        256b        18.9 MiB/s        18.8 MiB/s
```

(1MB blocks)

| S.<d/>No | Write (MB/s) | Read (MB/s) |
| -------- | ------------ | ----------- |
| 1        | 14.0         | 10.7        |
| 2        | 17.2         | 10.6        |
| 3        | 14.0         | 10.7        |
| 4        | 13.4         | 10.6        |
| 5        | 15.2         | 10.7        |

---

## Without Hardware Acceleration (CAAM)

```log
root@imx6ulevk:~# cat /proc/crypto
name         : cbc(aes)
driver       : cbc(aes-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16

name         : xts(aes)
driver       : xts(ecb(aes-generic))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
chunksize    : 16
walksize     : 16

root@imx6ulevk:~# cryptsetup benchmark
# Tests are approximate using memory only (no storage IO).
#     Algorithm |       Key |      Encryption |      Decryption
        aes-cbc        256b         8.5 MiB/s         8.5 MiB/s
        aes-xts        256b        11.6 MiB/s        10.7 MiB/s
```

(1MB blocks)

| S.<d/>No | Write (MB/s) | Read (MB/s) |
| -------- | ------------ | ----------- |
| 1        | 9.3          | 5.8         |
| 2        | 9.4          | 5.8         |
| 3        | 9.3          | 5.8         |
| 4        | 9.3          | 5.8         |
| 5        | 8.9          | 5.8         |

---

# References:

1. AN12714 i.<d/>MX Encrypted Storage Using CAAM Secure Keys - https://www.mouser.com/pdfDocs/AN12714.pdf
2. Linux Cryptographic Acceleration on an i.<d/>MX6 - http://events17.linuxfoundation.org/sites/events/files/slides/2017-02%20-%20ELC%20-%20Hudson%20-%20Linux%20Cryptographic%20Acceleration%20on%20an%20MX6.pdf
3. Dm-crypt - https://wiki.gentoo.org/wiki/Dm-crypt
4. Dm-crypt full disk encryption - https://wiki.gentoo.org/wiki/Dm-crypt_full_disk_encryption
5. cryptsetup - Linux man page - https://linux.die.net/man/8/cryptsetup
