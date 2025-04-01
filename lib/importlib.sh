#!/bin/bash
# Copyright 2025 Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

declare -a _LIB_IMPORTED
declare -g DEBUG_MODE=false

# Prevent re-importing the library if already loaded
if [ ${#_LIB_IMPORTED} -ne 0 ]; then
  return
fi

# Function to display an error message
ErrMsg() {
  printf "\033[0;31mERROR:\033[0m $@\n" >&2
}

# Function to display a warning message
WarnMsg() {
  printf "\033[1;33mWARNING:\033[0m $@\n" >&2
}

# Function to display a success message
OkMsg() {
  printf "\033[0;32mOK:\033[0m $@\n" >&2
}

# Function to display debug messages if DEBUG_MODE is enabled
DbMsg() {
  $DEBUG_MODE && caller
  $DEBUG_MODE && printf "\033[1;33mDEBUG:\033[0m $@\n" >&2
}

# Function to get the current directory of the script
get_current_dir() {
  local relative_path=$(dirname ${BASH_SOURCE[0]})
  if [ -n "$relative_path" ]; then
    pushd $(dirname ${BASH_SOURCE[0]}) 2>&1 1>/dev/null
    pwd
    popd 2>&1 1>/dev/null
  else
    pwd
  fi
}

_LIB_ROOT=$(get_current_dir)

# Function to find the source file of a library
find_lib_source() {
  local libname=$1
  find $_LIB_ROOT/../ -name $libname.sh | head -n1
}

# Function to check if a library is already imported
is_lib_imported() {
  local libname=$1
  local in_list=0
  for lib in "${_LIB_IMPORTED[@]}"; do
    if [ ${libname} == $lib ]; then
      in_list=1
      break
    fi
  done
  [ $in_list -eq 1 ]
}

# Function to register a library as imported
register_lib() {
  local lib_name=$1
  _LIB_IMPORTED[${#_LIB_IMPORTED[@]}]=$lib_name
}

# Function to import a single library
import_lib() {
  local libname=$1
  if is_lib_imported $libname; then
    return
  fi
  local libsource=$(find_lib_source $1)
  if [ -z "$libsource" ]; then
    ErrMsg "can't find lib:$libname"
    return
  fi
  source $libsource
  register_lib $libname
}

# Function to import multiple libraries
import_libs() {
  for libname in $@; do
    import_lib $libname
  done
}

# Register the importlib library itself
register_lib importlib