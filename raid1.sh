#!/usr/local/bin/bash

devices="ada0 ada1"
swap_size="2G"
l_boot=""
l_swap=""
l_root=""

for d in $devices
do
  echo gpart destroy -F /dev/$d
  echo gpart create -s gpt /dev/$d

  echo gpart add -s 128k -t freebsd-boot /dev/$d
  echo gpart add -a 1m -s $swap_size -t freebsd-swap /dev/$d
  echo gpart add -a 1m -t freebsd-ufs /dev/$d

  echo gpart bootcode -b /boot/pmbr -p /boot/gptboot -i 1 /dev/$d

  l_boot="$l_boot /dev/${d}p1"
  l_swap="$l_swap /dev/${d}p2"
  l_root="$l_root /dev/${d}p3"
done

echo gmirror label -vb round-robin boot $l_boot
echo gmirror label -vb round-robin swap $l_swap
echo gmirror label -vb round-robin root $l_root

kldload geom_mirror
gmirror status
echo 'geom_mirror_load="YES"' >> /tmp/bsdinstall_boot/loader.conf

newfs -U -L root /dev/mirror/root
mount /dev/mirror/root /mnt

cat <<EOF > /tmp/bsdinstall_etc/fstab
# Device          Mountpoint      FStype  Options Dump    Pass#
/dev/mirror/root  /               ufs     rw      1       1
/dev/mirror/swap  none            swap    sw      0       0
EOF
cat /etc/resolv.conf > /tmp/bsdinstall_etc/resolv.conf

# EOF