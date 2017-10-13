#!/bin/sh

BOARD_DIR="$(dirname $0)"
CURR_DIR="$(pwd)"
BRANCH=$2
OUTPUT=$(basename ${BASE_DIR})

GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

# Create the kernel FIT file
cp ${BOARD_DIR}/kubos-kernel.its ${BINARIES_DIR}/
cd ${BR2_EXTERNAL_KUBOS_LINUX_PATH}/tools
./kubos-kernel.sh -b ${BRANCH} -i ${BINARIES_DIR}/kubos-kernel.its -o ${OUTPUT}

mv kubos-kernel.itb ${BINARIES_DIR}/kernel
cd ${CURR_DIR}

# Create the user data partition
dd if=/dev/zero of=userpart.img bs=1M count=2000
mkfs.ext4 userpart.img
losetup /dev/loop0 userpart.img
mkdir /tmp-kubos
mount /dev/loop0 /tmp-kubos
cp ${BR2_EXTERNAL_KUBOS_LINUX_PATH}/common/user-overlay/* /tmp-kubos -R

# Create the microSD user data partition mount point
mkdir /tmp-kubos/microsd

# Cleanup
umount /dev/loop0
rmdir /tmp-kubos
losetup -d /dev/loop0

mv userpart.img ${BINARIES_DIR}/userpart.img

# Generate the images
genimage \
    --rootpath "${TARGET_DIR}" \
    --tmppath "${GENIMAGE_TMP}" \
    --inputpath "${BINARIES_DIR}" \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}"
