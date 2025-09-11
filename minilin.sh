#!/bin/bash

mkdir src
cd src

    # --build the kernel--
    wget https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.9.8.tar.xz
    tar -xf linux-6.9.8.tar.xz
    cd linux-6.9.8
        make defconfig # to compile the kernel
        make -j8||exit # run 8 parallel job for faster compile time
    cd ..


    # --build busybox--
    wget https://busybox.net/downloads/busybox-1.37.0.tar.bz2
    tar -xf busybox-1.37.0.tar.bz2
    cd busybox-1.37.0
        make defconfig # to compile busybox
        sed 's/^.*CONFIG_STATIC[^_].*$/CONFIG_STATIC=y/g' -i .config  # to compile in static mode
        make -j8||exit # run 8 parallel job for faster compile time
    cd ..

cd ..
cp src/linux-6.9.8/arch/x86_64/boot/bzImage ./  # copy the compiled kernel into the root dir

# --create rootfs
mkdir initrd
cd initrd
    # create rootfs directories bin(busybox) dev(device files) proc(process files) sys(kernel)
    mkdir bin dev proc sys
    cd bin
        cp ../../src/busybox-1.37.0/busybox ./ # copy the compiled busybox binary
        # add symlinks for busybox tools
        for tool in $(./busybox --list); do
            ln -s /bin/busybox ./$tool 
        done
    cd ..
    # create a script called init to tell the kernel what to do at start
    echo '#!bin/sh' > init
    echo 'mount -t sysfs sysfs /sys' >> init
    echo 'mount -t proc proc /proc' >> init
    echo 'mount -t devtmpfs udev /dev' >> init
    echo 'clear' >> init
    echo '/bin/sh' >> init
    echo 'poweroff -f' >> init # skip usual shutdown panic
    chmod 777 init
    find . | cpio -o -H newc > ../initrd.img # archive all the rootfs into one initrd image

cd ..

qemu-system-x86_64 -kernel bzImage -initrd initrd.img
