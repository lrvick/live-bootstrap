# SPDX-FileCopyrightText: 2022 Dor Askayo <dor.askayo@gmail.com>
# SPDX-FileCopyrightText: 2022 Andrius Štikonas <andrius@stikonas.eu>
#
# SPDX-License-Identifier: GPL-3.0-or-later

src_configure() {
    ./configure \
        --host=i386-unknown-linux-musl \
        --prefix="${PREFIX}" \
        --libdir="${LIBDIR}" \
        --includedir="${PREFIX}/include/"
}

src_compile() {
    make CROSS_COMPILE=
}

src_install() {
    default

    # Make dynamic linker symlink relative in ${PREFIX}/lib
    rm "${DESTDIR}/lib/ld-musl-i386.so.1"
    rmdir "${DESTDIR}/lib"
    mkdir -p "${DESTDIR}${PREFIX}/lib"
    ln -sr "${DESTDIR}${LIBDIR}/libc.so" "${DESTDIR}${PREFIX}/lib/ld-musl-i386.so.1"

    # Add symlink for ldd
    mkdir -p "${DESTDIR}${PREFIX}/bin"
    ln -s ../lib/ld-musl-i386.so.1 "${DESTDIR}${PREFIX}/bin/ldd"

    # Add library search path configurtion
    mkdir -p "${DESTDIR}/etc"
    cp ld-musl-i386.path "${DESTDIR}/etc"

    # Re-add /bin and /lib symlinks here so that binary package
    # is self-contained and usable outside live-bootstrap
    ln --symbolic --relative "${DESTDIR}/${PREFIX}/lib" "${DESTDIR}/lib"
    ln --symbolic --relative "${DESTDIR}/${PREFIX}/bin" "${DESTDIR}/bin"
}
