#! /usr/bin/env bash

# This script download official Ubuntu server for Raspberry pi
# Write it to sd card and copy cloud-init config
# Check canoncial for official pi ubuntu version https://ubuntu.com/download/raspberry-pi

if [ $# -ne 1 ]; then
    echo "Usage: $0 <device>"
    echo "Example: $0 /dev/mmcblk0"
    exit 1
fi

VERSION=${os_version}
IMAGE=${os_name}.img
DEVICE=$1

# Download if not exists
if [[ ! -f "$IMAGE" && ! -f "$IMAGE.xz"  ]]; then
    echo "No $IMAGE or $IMAGE.xz found. Downloading..."
    wget "https://cdimage.ubuntu.com/releases/$VERSION/release/$IMAGE.xz"
    echo "Unpacking..."
    unxz "$IMAGE.xz"
fi

# Unpack if .xz exists
if [[ ! -f "$IMAGE" && -f "$IMAGE.xz" ]]; then
    echo "$IMAGE.xz found. Unpacking..."
    unxz "$IMAGE.xz"
fi

echo "Image $IMAGE ready to write to SD card!"

# Verify device exists
if [ ! -b "$DEVICE" ]; then
    echo "Error: Device $DEVICE does not exist or is not a block device"
    exit 1
fi

# Verify image exists
if [ ! -f "$IMAGE" ]; then
    echo "Error: Image file $IMAGE does not exist"
    exit 1
fi

# Show device info
echo "Device information:"
sudo fdisk -l "$DEVICE"

# Final confirmation
echo
echo "WARNING: This will COMPLETELY ERASE $DEVICE!"
echo "All data on $DEVICE will be lost!"
read -p "Type 'yes' to continue: " confirm

if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    exit 1
fi

# Unmount partitions
echo "Unmounting partitions..."
sudo umount "$DEVICE"* 2>/dev/null

# Write image
echo "Writing $IMAGE to $DEVICE..."
sudo dd if="$IMAGE" of="$DEVICE" bs=4M status=progress oflag=sync

# Final sync
sync
echo "Write completed successfully!"

BOOT_MOUNT=/mnt/piboot
sudo mkdir -p $BOOT_MOUNT

# Mount 1st boot partition
sudo mount "$DEVICE"p1 $BOOT_MOUNT

# Copy cloud-init config files
sudo cp ${hostname}-${role}-user-data $BOOT_MOUNT/user-data
sudo cp ${hostname}-${role}-meta-data $BOOT_MOUNT/meta-data
sudo cp ${hostname}-${role}-network-config $BOOT_MOUNT/network-config