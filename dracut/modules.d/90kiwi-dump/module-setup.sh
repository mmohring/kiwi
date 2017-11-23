#!/bin/bash

# called by dracut
depends() {
    echo rootfs-block dm
    return 0
}

# called by dracut
installkernel() {
    instmods squashfs loop iso9660
}

# called by dracut
install() {
    declare moddir=${moddir}
    inst_hook cmdline 30 "${moddir}/parse-kiwi-install.sh"
    inst_hook pre-udev 30 "${moddir}/kiwi-install-genrules.sh"
    inst_script "${moddir}/kiwi-dump-image.sh" "/sbin/kiwi-dump-image"
    dracut_need_initqueue
}
