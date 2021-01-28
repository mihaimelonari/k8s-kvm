FROM registry.gitlab.com/qemu-project/qemu/qemu/fedora:latest

ENV QEMU_VERSION=v5.2.0

WORKDIR /root

RUN git clone --depth 1 --branch ${QEMU_VERSION} git://git.qemu.org/qemu.git && \
    cd qemu && \
    mkdir build && \
    cd build && \
    ../configure \
        --enable-werror \
        --extra-cflags="-fno-omit-frame-pointer" \
        --target-list="x86_64-softmmu" \
        --disable-gcrypt \
        --enable-nettle \
        --enable-docs \
        --enable-fdt=system \
        --enable-slirp=system \
        --enable-capstone=system && \
    make -j2 && \
    make install && \
    dnf -y update && \
    dnf -y install \
        bridge-utils \
        gnupg \
        iproute \
        libattr \
        libattr-devel \
        net-tools \
        socat \
        xfsprogs && \
    dnf clean all

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY qemu-ifup /etc/qemu-ifup
COPY qemu-shutdown /qemu-shutdown
COPY qemu-node-setup /qemu-node-setup

ENTRYPOINT ["/docker-entrypoint.sh"]
