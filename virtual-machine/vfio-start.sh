#!/bin/bash
# Helpful to read output when debugging
set -x

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 3

# Unload all Nvidia drivers
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia
# Looks like these might need to be unloaded on Ryzen Systems. Not sure yet.
modprobe -r ipmi_devintf
modprobe -r ipmi_msghandler

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_02_00_0
virsh nodedev-detach pci_0000_02_00_1
virsh nodedev-detach pci_0000_02_00_2
virsh nodedev-detach pci_0000_02_00_3

# Load VFIO Kernel Module  
modprobe vfio-pci  
