#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import_libs alt_touchpad_cmt_util

# Function to initialize and show the alternative touchpad CMT menu
init_alt_touchpad_cmt_and_show() {
  register_console alt_touchpad_cmt 
}

# Function to initialize the alternative touchpad CMT configuration
alt_touchpad_cmt_console_in() {
  init_alt_touchpad_cmt_conf
}

# Function to use a specific alternative touchpad configuration
use_alt_touchpad_config() {
  local option="$1"
  if [ "$option" -eq 0 ]; then
    disable_alt_touchpad_cmt_config
  fi
  for i in {1..4}; do
    if [ "$i" -eq "$option" ]; then
      select_alt_touchpad_cmt_config "$i"
      return
    fi
  done
}

# Function to describe the alternative touchpad configuration
alt_touchpad_cmt_config_desc() {
  local option="$1"
  local prefix=""
  local current=""
  current=$(current_alt_touchpad_cmt_config)
  if [ "$option" -eq 0 ]; then
    prefix="Native touchpad config"
    if [ "$current" -eq "$option" ]; then
      echo "$prefix (default, selected)"
    else
      echo "$prefix (default)"
    fi
    return
  fi
  for i in {1..4}; do
    if [ "$i" -eq "$option" ]; then
      prefix="Alternative touchpad config $i"
      if [ "$current" -eq "$option" ]; then
        echo "$prefix (selected)"
      else
        echo "$prefix"
      fi
      return
    fi
  done
}

# Function to register alternative touchpad configuration options
register_alt_touchpad_cmt_options() {
  WarnMsg "Reboot or restart UI to apply the changes."
  for i in {0..4}; do
    register_item_and_description "use_alt_touchpad_config $i" \
      "$(alt_touchpad_cmt_config_desc "$i")"
  done
}

# Function to show the alternative touchpad CMT menu
alt_touchpad_cmt_show_menu() {
  register_alt_touchpad_cmt_options
}