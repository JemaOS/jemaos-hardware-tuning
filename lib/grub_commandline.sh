#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Global variables for GRUB configuration
declare -g _RO_MODULE_PARAMS="moduleparams="  # Key for module parameters in GRUB
declare -g _RO_MODULE_VAR="\$moduleparams"   # Variable for module parameters
declare -g _RO_BLACKLIST="module_blacklist"  # Key for module blacklist
declare -g GRUB_MNT="/tmp/grub_mnt"         # Temporary mount point for GRUB
declare -g CURRENT_GRUB_FILE                # Current GRUB configuration file
declare -g CURRENT_MODULE_PARAMS            # Current module parameters

# Function to retrieve module parameters from a GRUB configuration file
get_module_params() {
  local grubfile=${1:-$CURRENT_GRUB_FILE}
  local module_params=$(cat $grubfile | grep $_RO_MODULE_PARAMS)
  module_params=${module_params#*=}
  echo ${module_params} | sed "s/\"//g"
}

# Function to save module parameters to a GRUB configuration file
save_module_params() {
  local grubfile=${1:-$CURRENT_GRUB_FILE}
  local module_params="${2:-$CURRENT_MODULE_PARAMS}"
  if [ ! -e $grubfile.orig ]; then
    sudo cp $grubfile $grubfile.orig
  fi
  if [ -n "$(cat $grubfile | grep $_RO_MODULE_PARAMS)" ]; then
    sudo sh -c "sed \"/$_RO_MODULE_PARAMS/  c $_RO_MODULE_PARAMS\\\"$module_params\\\"\"  $grubfile > $grubfile.new"
  else
    sudo sh -c  "sed \"1 i $_RO_MODULE_PARAMS\\\"$module_params\\\"\" $grubfile > $grubfile.new"
  fi
  if [ -z "$(cat $grubfile.new | grep $_RO_MODULE_VAR)" ]; then
    sudo sed "s/ linux.*/& $_RO_MODULE_VAR/"  -i $grubfile.new 
  fi
  sudo mv $grubfile $grubfile.bak
  sudo mv $grubfile.new $grubfile
}

# Function to retrieve a specific parameter from module parameters
get_param_from_module_params() {
  local module_params="$1"
  local param="$2"
  for arg in $module_params; do
    if [ "${arg%=*}" == "$param" ]; then
      echo $arg
      break
    fi
  done
}

# Function to set a parameter in module parameters
set_param_to_module_params() {
  local module_params="$1"
  local param="$2"
  local find_param=false
  local result=""
  for arg in $module_params; do
    arg=$(echo $arg | xargs)
    if [ -z "$arg" ]; then
      continue
    fi
    if [ "${arg%=*}" == "${param%=*}" ]; then
      find_param=true
      result+="$param "
    else
      result+="$arg "
    fi
  done
  if ! $find_param; then
    result+="$param "
  fi
  echo ${result% }
}

# Function to unset a parameter from module parameters
unset_param_to_module_params() {
  local module_params="${1:-$CURRENT_MODULE_PARAMS}"
  local param="$2"
  local result=""
  for arg in $module_params; do
    if [ "${arg%=*}" != "${param%=*}" ]; then
      result+="$arg "
    fi
  done
  echo ${result% }
}

# Function to retrieve the blacklist from module parameters
get_blacklist() {
  local module_params="${1:-$CURRENT_MODULE_PARAMS}"
  local blacklist=$(get_param_from_module_params "$module_params" $_RO_BLACKLIST)
  echo ${blacklist#*=}
}

# Function to set the blacklist in module parameters
set_blacklist() {
  local module_params="$1"
  local blacklist="$2"
  set_param_to_module_params "$module_params" "$_RO_BLACKLIST=$blacklist"
}

# Function to check if a module is blocked
is_module_blocked() {
  local blacklist=$1
  local name=$2
  local find_name=false
  local IFS=","
  for module in $blacklist; do
    if [ "$name" == "$module" ]; then
      find_name=true
      break
    fi
  done
  IFS=""
  $find_name
}

# Function to add a module to the blacklist
set_blacklist_name() {
  local blacklist=$1
  local name=$2
  local find_name=false
  local result=""
  local IFS=","
  for module in $blacklist; do
    if [ "$name" == "$module" ]; then
      find_name=true
    fi
    result+="$module,"
  done
  IFS=""
  if $find_name; then
    echo ${result%,}
  else
    echo $result$name
  fi
}

# Function to remove a module from the blacklist
unset_blacklist_name() {
  local blacklist=$1
  local name=$2
  local IFS=","
  local result=""
  for module in $blacklist; do
    if [ "$name" != "$module" ]; then
      result+="$module,"
    fi
  done
  IFS=""
  echo ${result%,}
}

# Function to initialize the GRUB mount point
init_grub_mnt() {
  [ -d $GRUB_MNT ] || mkdir $GRUB_MNT
  if [ -n "$(cat /proc/cmdline | grep jemaos_dualboot)" ]; then
    local dualboot_part=$(sudo cgpt find -l JEMAOS-DUAL-BOOT)
    dualboot_part=$(udevadm info -q path $dualboot_part)
    dualboot_part=$(dirname $dualboot_part)
    dualboot_part=$(basename $dualboot_part)
    dualboot_part=$(sudo cgpt find -t efi /dev/$dualboot_part | head -n1)
    sudo mount $dualboot_part $GRUB_MNT
    CURRENT_GRUB_FILE=$GRUB_MNT/efi/jemaos/grub.cfg
  else
    [ -n "$(sudo mount | grep $GRUB_MNT)" ] || \
      sudo mount $(ls $(rootdev -d){12,p12} 2>/dev/null) $GRUB_MNT
    CURRENT_GRUB_FILE=$GRUB_MNT/efi/boot/grub.cfg
  fi
  CURRENT_MODULE_PARAMS="$(get_module_params)"
}

# Function to release the GRUB mount point
release_grub_mnt() {
  local params=$(get_module_params $CURRENT_GRUB_FILE)
  if [ "${CURRENT_MODULE_PARAMS}" != "$params" ]; then
    save_module_params "$CURRENT_GRUB_FILE" "$CURRENT_MODULE_PARAMS"
    WarnMsg "The kernel module configuration has been changed, reboot to apply the change."
  fi
  sudo umount $GRUB_MNT 
}

# Function to block a module
block_module() {
  local modname=$1
  local bl=$(get_blacklist "${CURRENT_MODULE_PARAMS}")
  bl=$(set_blacklist_name "$bl" "$modname")
  CURRENT_MODULE_PARAMS="$(set_blacklist "${CURRENT_MODULE_PARAMS}" "$bl")"
}

# Function to unblock a module
unblock_module() {
  local modname=$1
  local bl=$(unset_blacklist_name "$(get_blacklist "${CURRENT_MODULE_PARAMS}")" $modname)
  CURRENT_MODULE_PARAMS="$(set_blacklist "${CURRENT_MODULE_PARAMS}" "$bl")"
}

# Function to set a module parameter
set_module_parameter() {
  local param="$1"
  CURRENT_MODULE_PARAMS="$(set_param_to_module_params "$CURRENT_MODULE_PARAMS" "$param")"
}

# Function to unset a module parameter
unset_module_parameter() {
  local param="$1"
  CURRENT_MODULE_PARAMS="$(unset_param_to_module_params "$CURRENT_MODULE_PARAMS" "$param")"
}

# Function to check if a module is blocked
is_blocked_module() {
  local search_module="$1"
  local bl=$(get_blacklist "${CURRENT_MODULE_PARAMS}")
  is_module_blocked $bl $search_module
}