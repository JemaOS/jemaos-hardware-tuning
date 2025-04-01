#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Function to check if a variable is an indexed array
is_idarray() {
  [[ "$(declare -p $1 2>&1)" =~ "declare -a" ]] 
}

# Function to check if a variable is an associative array
is_assarray() {
  [[ "$(declare -p $1 2>&1)" =~ "declare -A" ]]
}

# Function to convert an indexed array to a JSON array string
idarray_to_json() {
  local -n arr=$1  # Reference the array passed as the first argument
  local jsonstr="["
  local val
  for val in ${arr[@]}; do
    jsonstr+=\"$val\",\  # Append each value to the JSON string
  done
  echo "${jsonstr%,}]"  # Remove the trailing comma and close the JSON array
}

# Function to convert an associative array to a JSON object string
assarray_to_json() {
  local -n assarr=$1  # Reference the associative array passed as the first argument
  local jsonstr="{"
  local name
  for name in "${!assarr[@]}"; do
    jsonstr+=\""$name"\"\:\"${assarr["$name"]}\",  # Append each key-value pair to the JSON string
  done
  echo "${jsonstr%,}}"  # Remove the trailing comma and close the JSON object
}

# Function to clear the contents of an array (indexed or associative)
clear_array() {
  if is_idarray $1; then
    unset $1  # Unset the indexed array
    declare -ga $1  # Re-declare it as a global indexed array
  elif is_assarray $1; then
    unset $1  # Unset the associative array
    declare -gA $1  # Re-declare it as a global associative array
  fi
}