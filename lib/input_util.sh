#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

declare -g SYS_CLASS_INPUT_PATH="/sys/class/input"
declare -Ag _INPUT_TYPES=(
  ["Touchpad"]="ID_INPUT_TOUCHPAD=1"
  ["PointingStick"]="ID_INPUT_POINTINGSTICK=1"
  ["Mouse"]="ID_INPUT_MOUSE=1"
  ["Touchscreen"]="ID_INPUT_TOUCHSCREEN=1"
  ["Tablet"]="ID_INPUT_TABLET=1"
)
declare -g _CURRENT_INPUT_DEV=""

# Function to set the current input device
set_current_input_device() {
  _CURRENT_INPUT_DEV=$1
}

# Function to list all input device paths
list_input_devices_path() {
  ls -d $SYS_CLASS_INPUT_PATH/input* 2>/dev/null
}

# Function to get the name of an input device
input_device_name() {
  local dev_path=${1:-$_CURRENT_INPUT_DEV}
  cat $dev_path/name
}

# Function to get the event device path of an input device
input_device_event_dev() {
  local dev_path=${1:-$_CURRENT_INPUT_DEV}
  local event_path=$(ls -d $dev_path/event* 2>/dev/null)

  if [ -z "$event_path" ]; then
    echo ""
  else
    local evname=$(basename $event_path)
    echo /dev/input/$evname
  fi
}

# Function to test an input device using evtest
input_device_evtest() {
  local dev_path=${1:-$_CURRENT_INPUT_DEV}
  evtest $(input_device_event_dev $dev_path)
}

# Function to get the properties of an input device
input_device_properties() {
  local dev_path=${1:-$_CURRENT_INPUT_DEV}
  udevadm info -q property $dev_path 
}

# Function to determine the type of an input device
input_device_type() {
  local dev_path=${1:-$_CURRENT_INPUT_DEV}
  for key in "${!_INPUT_TYPES[@]}"; do
    if [ -n "$(input_device_properties $dev_path | grep ${_INPUT_TYPES["$key"]})" ]; then
      echo $key
      break
    fi
  done
}

# Function to get the driver name of an input device
input_device_driver_name() {
  local dev_path=${1:-$_CURRENT_INPUT_DEV}
  local dname=$(udevadm info -q property $dev_path/device | grep "DRIVER=")
  echo ${dname#DRIVER=}
}