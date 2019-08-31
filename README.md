# freebsd-install
Some scripts for FreeBSD

## raid1.sh
Manual partitioning and installing FreeBSD to RAID1 (gmirror).
When installing from network, sometimes MANIFEST should be downloaded:
```
mkdir /usr/freebsd-dist
fetch -o /usr/freebsd-dist/MANIFEST ftp://ftp.freebsd.org/pub/FreeBSD/releases/amd64/amd64/11.2-RELEASE/MANIFEST
```
