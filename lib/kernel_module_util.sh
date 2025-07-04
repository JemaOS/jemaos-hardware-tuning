#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import_lib console grub_commandline

# Function to list kernel module parameters
list_kernel_module_params() {
  local module=$1
  local p1 param detail value
  local -i index=0
  printf "Module:[ ${_WHITE}$module${_NC} ]\n"
  while IFS=":" read -s p1 param detail; do
    param=$(echo $param | xargs)
    if [ -z "$param" ]; then
      break
    fi
    printf "($((index++))) ${_WHITE}$param${_NC}: $(sudo cat /sys/module/$module/parameters/$param)\n"
    printf "$detail\n"
  done <<< $(sudo modinfo $module 2>/dev/null | grep parm)
}

# Function to block a kernel module and save the command
block_module_command() {
  local mod=$1
  save_command "block_module $mod" "Block driver \"$mod\" to prevent it being used by the system."
  WarnMsg "The block command was saved temporarily, you can revoke it by removing the last saved command."
}

# Function to unblock a kernel module and save the command
unblock_module_command() {
  local mod=$1
  save_command "unblock_module $mod" "Unblock driver \"$mod\" to allow it to be used by the system."
  WarnMsg "The unblock command was saved temporarily, you can revoke it by removing the last saved command."
}

# Function to register block or unblock actions for a kernel module
register_block_or_unblock_item() {
  local mod=$1
  if is_blocked_module $mod; then
    register_item_and_description "unblock_module_command $mod" \
      "Unblock kernel driver/module: ($mod)." 
  else
    register_item_and_description "block_module_command $mod" \
      "Block kernel driver/module: ($mod)."
  fi
}

# Function to check if a kernel module is blocked in the system
is_blocked_in_system() {
  local module=$1
  local module_params=$(cat /proc/cmdline)
  local bl=$(get_param_from_module_params "$module_params" $_RO_BLACKLIST)
  local blocked=false
  bl=${bl#*=}
  if is_module_blocked $bl $module; then
    DbMsg "$module is blocked"
    blocked=true
  fi
  $blocked
}