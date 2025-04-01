#!/usr/bin/env bash

import_libs suspend_mode
import_libs update_refind

# Function to list PCI devices
ls_pci() {
    sudo lspci -nn
}

# Function to list USB devices
ls_usb() {
    sudo lsusb
}

# Function to list HID devices from dmesg
ls_hid() {
    sudo dmesg | grep -i "hid"
}

# Function to show dmesg warnings and errors
show_dmesg() {
    sudo dmesg --level=err,warn
}

# Function to display IP addresses
ip_addrs() {
    ip addr
}

# Function to list miscellaneous system information
list_misc_info() {
    display_header "HID DEVICES"
    ls_hid
    echo ""

    display_header "PCI DEVICES"
    ls_pci
    echo ""

    display_header "USB DEVICES"
    ls_usb
    echo ""

    display_header "DMESG WARN/ERROR"
    show_dmesg | grep -v audit
    echo ""

    display_header "IP ADDRESSES"
    ip_addrs
    echo ""
}

# Function to show the miscellaneous menu
misc_show_menu() {
    register_item_and_description "init_suspend_mode_and_show" \
        "Switch suspend mode"
    if grep -q jemaos_dualboot /proc/cmdline; then
        register_item_and_description "init_update_refind_and_show" \
            "Update rEFInd provided by JemaOS"
    fi
}

# Function to check if the miscellaneous menu is supported
misc_menu_supported() {
    is_setting_suspend_mode_support
}