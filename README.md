# Busybox Image
This repository contains a script that builds a minimal Linux-based OS using the Linux kernel and busy-box
## Features:
Automates the process of:
- downloading the `Linux` kernel and compiling it
- downloading `busybox`, compiling it and add sym-links of all its tools inside the bin directory
- creating `rootfs` directories such as `bin`, `dev`, `proc` and `sys`
- creating an init script to mount the directories of the rootfs
- building `initrd.img` that holds the `busybox` binary and `rootfs`
- running the created image using `qemu`

## How to Use:
### Step 1: Install the needed libraries (if not already installed) using `setup.sh`

  ```
  ./setup.sh
  ```

### Step 2: Create the minimal linux based OS using `minilin.sh`
  ```
  ./minilin.sh
  ```