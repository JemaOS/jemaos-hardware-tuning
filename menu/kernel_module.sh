#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import_lib grub_commandline module_param

init_grub_mnt

# Function to change the current kernel module
change_current_module() {
  local module
  read -p "Input new module name:" module
  module=$(echo $module | xargs)
  if [ -n "$module" ]; then
    set_current_module $module
    show_menu
  else
    WarnMsg "No module name input."
  fi
}

# Function to show the kernel parameters menu
kernel_params_show_menu() {
  echo "Target kernel module:[$_CURRENT_MODULE]"
  register_item_and_description "change_current_module" \
    "Change current module"
  register_item_and_description "register_console module_param" \
    "Tuning module:$_CURRENT_MODULE parameters"
  register_block_or_unblock_item $_CURRENT_MODULE
}

# Function to show help for kernel module configuration
kernel_params_show_help() {
  echo "Setup kernel module parameters and blocklist manually."
}