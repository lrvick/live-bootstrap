#!/usr/bin/bash

# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
# SPDX-FileCopyrightText: 2021 fosslinux <fosslinux@aussies.space>
# SPDX-FileCopyrightText: 2021 Paul Dersey <pdersey@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

# shellcheck source=sysglobal/helpers.sh
. helpers.sh
# shellcheck source=/dev/null
. bootstrap.cfg

export PATH=/usr/bin:/usr/sbin
export PREFIX=/usr
export SOURCES=/usr/src
export DESTDIR=/tmp/destdir

create_fhs() {
    # Add the rest of the FHS that we will use and is not created pre-boot
    for d in bin lib sbin; do
        ln -s "usr/${d}" "/${d}"
    done
    mv /usr/sbin/* /usr/bin/
    rm -r /sbin /usr/sbin
    ln -s bin /usr/sbin
    ln -s bin /sbin
    mkdir /etc /proc /run /sys /tmp /var
    mount -t proc proc /proc
    mount -t sysfs sysfs /sys
    # Make /tmp a ramdisk (speeds up configure etc significantly)
    mount -t tmpfs tmpfs /tmp
}

populate_device_nodes ""

create_fhs

build bash-5.1

exec env -i PATH=${PATH} PREFIX=${PREFIX} SOURCES=${SOURCES} DESTDIR=${DESTDIR} bash run2.sh
