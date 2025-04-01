#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

declare -g SYS_CLASS_NET_PATH="/sys/class/net"
declare -g _CURRENT_WLAN=""

# Function to list all current wireless devices
list_current_wireless_devices() {
  pushd $SYS_CLASS_NET_PATH >/dev/null
  ls -d wlan* 2>/dev/null
  popd >/dev/null
}

# Function to check if a wireless device is on the PCI bus
is_pcibus_wireless_device() {
  local dev=${1:-$_CURRENT_WLAN}
  local module=$(udevadm info -q property $SYS_CLASS_NET_PATH/$dev | grep ID_BUS)
  [ "${module#*=}" == "pci" ]
}

# Function to set the current wireless device
set_current_wlan() {
  if [ -e "$SYS_CLASS_NET_PATH/$1" ]; then
    _CURRENT_WLAN=$1
  fi
  if [ -z "$_CURRENT_WLAN" ]; then
    _CURRENT_WLAN=$(list_current_wireless_devices | head -n1)
  fi
  if [ -z "$_CURRENT_WLAN" ]; then
    ErrMsg "No wireless interface was found (e.g. wlan0 etc.)"
  fi
}

# Function to run a wpa_cli command on a wireless device
wpa_cli_run() {
  local cmd="$1"
  local dev=${2:-$_CURRENT_WLAN}
  sudo -u wpa -- wpa_cli -i $dev $cmd
}

# Function to get the driver module of a wireless device
get_wireless_device_module() {
  local dev=${1:-$_CURRENT_WLAN}
  local module=$(udevadm info -q property $SYS_CLASS_NET_PATH/$dev | grep ID_NET_DRIVER)
  echo ${module#*=}
}

# Function to get the status of a wireless device
get_wireless_device_status() {
  local dev=${1:-$_CURRENT_WLAN}
  local status=$(wpa_cli_run status $dev | grep wpa_state)
  echo ${status#wpa_state=}
}

# Function to get the IPv4 address of a wireless device
get_wireless_device_ip4() {
  local dev=${1:-$_CURRENT_WLAN}
  local status=$(wpa_cli_run status $dev | grep ip_address)
  echo ${status#ip_address=}
}

# Function to scan for wireless networks
scan_wirless_networks() {
  local dev=${1:-$_CURRENT_WLAN}
  wpa_cli_run scan $dev
}

# Function to get SSIDs from scan results
scan_result_ssid_from_device() {
  local dev=${1:-$_CURRENT_WLAN}
  while read d1 d2 d3 d4 d5; do
    echo $d5
  done <<< $(wpa_cli_run scan_result $dev | tail -n +2)
}

# Function to list networks for a device
list_dev_networks() {
  local dev=${1:-$_CURRENT_WLAN}
  wpa_cli_run list_networks $dev | tail -n +2
}

# Function to get the number of networks for a device
number_of_networks() {
  local dev=${1:-$_CURRENT_WLAN}
  while read d1 d2; do
    echo $d1
  done <<< $(list_dev_networks | wc)
}

# Function to connect to a network using SSID and PSK
connect_ssid_from_dev() {
  local ssid="$1"
  local psk="$2"
  local dev=${3:-$_CURRENT_WLAN}
  local network_id=$(wpa_cli_run "add_network" $dev)
  wpa_cli_run "set_network $network_id ssid \"$ssid\"" $dev
  wpa_cli_run "set_network $network_id psk \"$psk\"" $dev
  wpa_cli_run "select_network $network_id" $dev
}