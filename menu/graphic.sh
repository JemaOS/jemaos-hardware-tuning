#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import_libs bus_pci_scan graphic_device kernel_module_util module_param

# Function to list graphic PCI device information
list_graphic_pci_info() {
  echo "System graphic device list:"
  for slot in $(get_slots_by_pci_types "graphic" "display"); do
    pci_device_info $slot
  done
  WarnMsg "Suggestions from JemaOS:"
  echo "Best compatible devices:" ${_BEST_COMPATIABLE_GCARDS[@]}  
  echo "Basic compatible devices:" ${_BASIC_COMPATIABLE_GCARDS[@]}
}

# Function to display graphic device information
graphic_list_info() {
  list_graphic_pci_info
}

# Function to show the graphic menu
graphic_show_menu() {
  graphic_list_info
  print_line "*"
  local IFS=' ,'
  for slot in $(get_slots_by_pci_types "graphic" "display"); do
    DbMsg "slot:$slot"
    for mod in $(get_device_kernel_modules $slot); do
      DbMsg "mod:$mod"
      register_item_and_description "init_module_param_and_show $mod" \
        "Tuning kernel module: ($mod) params."
      register_block_or_unblock_item $mod
    done 
  done
  register_item_and_description 'sudo dmesg | grep -i \"drm\|i915\|amdgpu\|nouveau\" |grep -i err' \
    "Search kernel message for graphic driver error"
}

# Function to display help for graphic configuration
graphic_show_help() {
  echo "JemaOS can only run on one graphic device at the moment. If there are two or more graphic devices in your system,\
     JemaOS may pick one randomly. You need to block the unused device or the system will not run stably."
  WarnMsg "If you block the wrong device, you may get a black screen."
}