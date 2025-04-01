#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import_libs bus_pci_scan module_param wireless_util connection

# Function to list wireless PCI device information
list_wireless_pci_info() {
  echo "System wireless PCI devices list:"
  for slot in $(get_slots_by_pci_type "wireless"); do
    pci_device_info $slot
  done  
}

# Function to list WLAN device information
list_wlan_info() {
  echo "System current WLAN device:"
  for wlan in $(list_current_wireless_devices); do
    printf "$wlan\tdriver:$(get_wireless_device_module $wlan)\t\
      status:$(get_wireless_device_status $wlan)\tip:$(get_wireless_device_ip4 $wlan)\n"
  done
}

# Function to show the connection panel for a specific device
show_connection_panel() {
  local dev="$1"
  set_current_wlan $dev
  register_console connection
}

# Function to list all wireless information
wireless_list_info() {
  list_wireless_pci_info
  list_wlan_info
}

# Function to show the wireless menu
wireless_show_menu() {
  wireless_list_info
  print_line "*"
  local msgfilter="\"wireless"
  for slot in $(get_slots_by_pci_type "wireless"); do
    for mod in $(get_device_kernel_modules $slot); do
       msgfilter+="\|$mod"
      register_item_and_description "init_module_param_and_show $mod" \
        "Tuning kernel module: ($mod) params."
      register_block_or_unblock_item $mod
    done
  done
  for wlan in $(list_current_wireless_devices); do
    if ! is_pcibus_wireless_device $wlan; then
      local mod=$(get_wireless_device_module $wlan)
      register_item_and_description "init_module_param_and_show $mod" \
        "Tuning kernel module: ($mod) params."
      register_block_or_unblock_item $mod
      msgfilter+="\|$mod"
    fi
    register_item_and_description "show_connection_panel $wlan" \
      "Connecting network with device:$wlan"
  done
}

# Function to show help for wireless configuration
wireless_show_help() {
  echo "Wireless device/driver/connection utilities all in one."
}