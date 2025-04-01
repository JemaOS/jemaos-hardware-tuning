#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import_lib grub_commandline

declare -g _CURRENT_MODULE=""

# Function to set the current kernel module
set_current_module() {
    _CURRENT_MODULE=$1
    DbMsg "set module:$1"
}

# Function to modify a parameter value
modify_param_value() {
  local param="$1"
  local val
  read -p "Input $param value and press ENTER, no value will remove it from configuration:" val
  val=$(echo $val | xargs)
  if [ -n "$val" ]; then
    save_command "set_module_parameter $_CURRENT_MODULE.$param=$val" "Set module:$_CURRENT_MODULE parameter:$param value:$val"
  else
    save_command "unset_module_parameter $_CURRENT_MODULE.$param" "Unset module:$_CURRENT_MODULE parameter:$param"
  fi 
}

# Function to test a parameter value
test_param_value() {
  local param="$1"
  local val
  read -p "Input $param value and press ENTER, an empty value will reload module with default parameter:" val
  val=$(echo $val | xargs)
  sudo rmmod $_CURRENT_MODULE
  if [ -z "$val" ]; then
    sudo modprobe $_CURRENT_MODULE
  else
    sudo modprobe $_CURRENT_MODULE "$param=$val"
  fi
}

# Function to force modify a parameter
force_modify_param() {
  local val
  read -p "Input [param] or [param=value] to write parameter to kernel driver configuration; [-param] to remove it from configuration(\"[]\" is not needed):" val
  val=$(echo $val | xargs)
  if [ -z "$val" ]; then
    WarnMsg "Input empty string, Nothing changed."
  elif [ ${val:0:1} == "-" ]; then
    save_command "unset_module_parameter $_CURRENT_MODULE.${val:1}" "Unset module:$_CURRENT_MODULE parameter:${val:1}"
  else
    save_command "set_module_parameter $_CURRENT_MODULE.$val" "Set module:$_CURRENT_MODULE parameter:$val"
  fi
}

# Function to show the kernel module parameter menu
module_param_show_menu() {
  local p1 param detail value
  local nomodule=true
  local isblocked=false
  is_blocked_in_system $_CURRENT_MODULE && isblocked=true
  printf "Module:[ ${_WHITE}$_CURRENT_MODULE${_NC} ]\n"
  while IFS=":" read -s p1 param detail; do
    param=$(echo $param | xargs)
    if [ -z "$param" ]; then
      break
    fi
    nomodule=false
    $isblocked || printf " ${_WHITE}$param${_NC}:$(sudo cat /sys/module/$_CURRENT_MODULE/parameters/$param)\n"
    printf "$detail\n"
    register_item_and_description "modify_param_value $param" \
      "Modify $param in system configuration"
    if ! $isblocked; then
      register_item_and_description "test_param_value $param" \
        "Reload kernel module with new $param but not changing system configuration"
    fi
    print_line "."
  done <<< $(sudo modinfo $_CURRENT_MODULE 2>/dev/null | grep parm)
  if $nomodule; then
    WarnMsg "No module or the module has no parameters. The driver may be compiled in the kernel, you can still change it."
    register_item_and_description "force_modify_param" \
      "Input \$param=value to set system configuration"
  fi
}

# Function to show help for kernel module parameters
module_param_show_help() {
  echo "None ensure it's safe for modifying kernel driver parameters, be cautious."
}

# Function to initialize and show the kernel module parameter menu
init_module_param_and_show() {
  local module=$1
  set_current_module $module
  register_console module_param
}