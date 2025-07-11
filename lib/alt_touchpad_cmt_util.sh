#!/bin/bash

# Copyright 2025 The Jema Technology. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

declare -rg _ALT_TOUCHPAD_CMT_CONF="/mnt/stateful_partition/unencrypted/gesture/55-alt-touchpad-cmt.conf"

init_alt_touchpad_cmt_conf() {
  local dir=""
  dir="$(dirname "${_ALT_TOUCHPAD_CMT_CONF}")"
  if [[ ! -d "$dir" ]]; then
    sudo mkdir -p "${dir}"
  fi
  if [[ ! -f "${_ALT_TOUCHPAD_CMT_CONF}" ]]; then
    sudo touch "${_ALT_TOUCHPAD_CMT_CONF}"
  fi
}

disable_alt_touchpad_cmt_config() {
  cat /dev/null > "$_ALT_TOUCHPAD_CMT_CONF"
}

get_alt_touchpad_cmt_config() {
  local option="$1"
  if [ "$option" -eq 1 ]; then
    cat <<TOUCHPADFIX
# Configure touchpads to use Chromium Multitouch (cmt) X input driver
Section "InputClass"
    Identifier      "touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Tap Minimum Pressure" "0"
    Option          "AccelerationProfile" "-1"
    Option          "Scroll Buttons" "0"
    Option          "Scroll Axes" "1"
    Option          "Touchpad Stack Version" "1"
    Option          "Integrated Touchpad" "1"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"

    # CMT devices potentially process keyboard events
    Option          "XkbModel" "pc"
    Option          "XkbLayout" "us"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Trackpad"
    MatchUSBID      "05ac:030e"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
# We are using raw touch major value as pressure value, so set the Palm
# pressure threshold high.
    Option          "Palm Pressure" "1000"
    Option          "Compute Surface Area from Pressure" "0"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    # TODO(clchiou): Calibrate bias on X-axis
    Option          "Touchpad Device Output Bias on X-Axis" "-283.3226025266607"
    Option          "Touchpad Device Output Bias on Y-Axis" "-283.3226025266607"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    # Disable drumroll suppression
    Option          "Drumroll Suppression Enable" "0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Trackpad 2"
    MatchUSBID      "05ac:0265|004c:0265"
    MatchDevicePath "/dev/input/event*"

    Option          "Pressure Calibration Offset" "30"
    Option          "Palm Pressure" "250.0"
    Option          "Palm Width" "20.0"
    Option          "Multiple Palm Width" "20.0"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"
    Option          "Finger Moving Energy" "0.0008"
    Option          "Finger Moving Hysteresis" "0.0004"

    # Avoid accidental scroll/move on finger lift
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Mouse"
    MatchUSBID      "05ac:030d"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "AccelerationProfile" "-1"
    Option          "Scroll X Out Scale" "3"
    Option          "Scroll Y Out Scale" "3"
    Option          "Compute Surface Area from Pressure" "0"
    Option          "Max Allowed Pressure Change Per Sec" "170.0"
    Option          "Max Hysteresis Pressure Per Sec" "170.0"
    Option          "Max Finger Stationary Speed" "94.32"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "Box Width" "8.0"
    Option          "Box Height" "1.0"
    # Resolution overrides:
    Option          "Vertical Resolution" "40"
    Option          "Horizontal Resolution" "45"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech Wireless Touchpad"
    MatchUSBID      "046d:4011"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-313.240741792594"
    Option          "Pressure Calibration Slope" "4.39678062436752"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Palm Pressure" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T650"
    MatchUSBID      "046d:4101"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-0.439288351750068"
    Option          "Pressure Calibration Slope" "3.05998553523335"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T651"
    MatchUSBID      "046d:b00c"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-4.46520447177073"
    Option          "Pressure Calibration Slope" "3.21071719332644"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T620"
    MatchUSBID      "046d:4027"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T400"
    MatchUSBID      "046d:4026"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech Bluetooth Touchmouse"
    MatchUSBID      "046d:b00d"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech TK820"
    MatchUSBID      "046d:4102"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Touchpad Stack Version" "2"
    # Pressure jumps around a lot on this touchpad, so allow that:
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Pressure Calibration Offset" "-18.8078435"
    Option          "Pressure Calibration Slope" "2.466208137"
EndSection

Section "InputClass"
    Identifier "CMT for Stantum"
    MatchDevicePath "/dev/input/event*"
    MatchProduct    "MTP_USB_Controller"
    Driver          "cmt"
    Option          "SendCoreEvents" "On"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "IIR Distance Threshold" "1000"
    Option          "Horizontal Resolution" "8"
    Option          "Vertical Resolution" "10"
    Option          "Two Finger Scroll Distance Thresh" "0.5"
    Option          "Pressure Calibration Offset" "1.0"
    Option          "Pressure Calibration Slope" "15.0"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "Whiskers Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchUSBID    "18D1:5030"

    # Use new touchpad gesture stack
    Option          "Touchpad Stack Version" "2"
    Option          "Integrated Touchpad" "1"

    Option          "Pressure Calibration Offset" "0.0"
    Option          "Pressure Calibration Slope"  "2"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"

    Option          "Box Width" "0.5"
    Option          "Box Height" "0.5"

    # Avoid accidental scroll/move on finger lift
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"

    # Suppress clicks without fingers on the pad.
    Option          "Zero Finger Click Enable" "0"

    Option          "Filter Low Pressure" "1"
    Option          "Pinch Enable" "1"
    Option          "Palm Pressure" "220.0"
    Option          "Palm Filter Top Edge Enable" "1"
    Option          "Smooth Accel" "1"
    Option          "Tap Minimum Pressure" "20.0"
EndSection

Section "InputClass"
    Identifier      "Brydge Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchUSBID      "03F6:A001"

    Option          "Fake Timestamp Delta" "0.010"
EndSection
TOUCHPADFIX
  elif [ "$option" -eq 2 ]; then
	  cat <<TOUCHPADFIX
# Configure touchpads to use Chromium Multitouch (cmt) X input driver
Section "InputClass"
    Identifier      "touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Tap Minimum Pressure" "0"
    Option          "AccelerationProfile" "-1"
    Option          "Scroll Buttons" "0"
    Option          "Scroll Axes" "1"
    Option          "Horizontal Resolution" "28"
    Option          "Vertical Resolution" "28"
    Option          "Integrated Touchpad" "1"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
    Option          "Smooth Accel" "1"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"

    # CMT devices potentially process keyboard events
    Option          "XkbModel" "pc"
    Option          "XkbLayout" "us"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Trackpad"
    MatchUSBID      "05ac:030e"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
# We are using raw touch major value as pressure value, so set the Palm
# pressure threshold high.
    Option          "Palm Pressure" "1000"
    Option          "Compute Surface Area from Pressure" "0"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    # TODO(clchiou): Calibrate bias on X-axis
    Option          "Touchpad Device Output Bias on X-Axis" "-283.3226025266607"
    Option          "Touchpad Device Output Bias on Y-Axis" "-283.3226025266607"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    # Disable drumroll suppression
    Option          "Drumroll Suppression Enable" "0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Trackpad 2"
    MatchUSBID      "05ac:0265|004c:0265"
    MatchDevicePath "/dev/input/event*"

    Option          "Pressure Calibration Offset" "30"
    Option          "Palm Pressure" "250.0"
    Option          "Palm Width" "20.0"
    Option          "Multiple Palm Width" "20.0"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"
    Option          "Finger Moving Energy" "0.0008"
    Option          "Finger Moving Hysteresis" "0.0004"

    # Avoid accidental scroll/move on finger lift
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Mouse"
    MatchUSBID      "05ac:030d"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "AccelerationProfile" "-1"
    Option          "Scroll X Out Scale" "3"
    Option          "Scroll Y Out Scale" "3"
    Option          "Compute Surface Area from Pressure" "0"
    Option          "Max Allowed Pressure Change Per Sec" "170.0"
    Option          "Max Hysteresis Pressure Per Sec" "170.0"
    Option          "Max Finger Stationary Speed" "94.32"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "Box Width" "8.0"
    Option          "Box Height" "1.0"
    # Resolution overrides:
    Option          "Vertical Resolution" "40"
    Option          "Horizontal Resolution" "45"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech Wireless Touchpad"
    MatchUSBID      "046d:4011"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-313.240741792594"
    Option          "Pressure Calibration Slope" "4.39678062436752"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Palm Pressure" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T650"
    MatchUSBID      "046d:4101"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-0.439288351750068"
    Option          "Pressure Calibration Slope" "3.05998553523335"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T651"
    MatchUSBID      "046d:b00c"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-4.46520447177073"
    Option          "Pressure Calibration Slope" "3.21071719332644"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T620"
    MatchUSBID      "046d:4027"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T400"
    MatchUSBID      "046d:4026"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech Bluetooth Touchmouse"
    MatchUSBID      "046d:b00d"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech TK820"
    MatchUSBID      "046d:4102"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Touchpad Stack Version" "2"
    # Pressure jumps around a lot on this touchpad, so allow that:
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Pressure Calibration Offset" "-18.8078435"
    Option          "Pressure Calibration Slope" "2.466208137"
EndSection

Section "InputClass"
    Identifier "CMT for Stantum"
    MatchDevicePath "/dev/input/event*"
    MatchProduct    "MTP_USB_Controller"
    Driver          "cmt"
    Option          "SendCoreEvents" "On"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "IIR Distance Threshold" "1000"
    Option          "Horizontal Resolution" "8"
    Option          "Vertical Resolution" "10"
    Option          "Two Finger Scroll Distance Thresh" "0.5"
    Option          "Pressure Calibration Offset" "1.0"
    Option          "Pressure Calibration Slope" "15.0"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "Whiskers Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchUSBID    "18D1:5030"

    # Use new touchpad gesture stack
    Option          "Touchpad Stack Version" "2"
    Option          "Integrated Touchpad" "1"

    Option          "Pressure Calibration Offset" "0.0"
    Option          "Pressure Calibration Slope"  "2"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"

    Option          "Box Width" "0.5"
    Option          "Box Height" "0.5"

    # Avoid accidental scroll/move on finger lift
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"

    # Suppress clicks without fingers on the pad.
    Option          "Zero Finger Click Enable" "0"

    Option          "Filter Low Pressure" "1"
    Option          "Pinch Enable" "1"
    Option          "Palm Pressure" "220.0"
    Option          "Palm Filter Top Edge Enable" "1"
    Option          "Smooth Accel" "1"
    Option          "Tap Minimum Pressure" "20.0"
EndSection

Section "InputClass"
    Identifier      "Brydge Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchUSBID      "03F6:A001"

    Option          "Fake Timestamp Delta" "0.010"
EndSection
TOUCHPADFIX
  elif [ "$option" -eq 3 ]; then
    cat <<TOUCHPADFIX
# Configure touchpads to use Chromium Multitouch (cmt) X input driver
Section "InputClass"
    Identifier      "touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "AccelerationProfile" "-1"
    Option          "Scroll Buttons" "0"
    Option          "Scroll Axes" "1"

    # CMT devices potentially process keyboard events
    Option          "XkbModel" "pc"
    Option          "XkbLayout" "us"
EndSection

Section "InputClass"
    Identifier      "CMT for Synaptics Touchpad"
    MatchUSBID      "06cb:*"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"

    # default calibration values for Synaptics firmware
    Option          "Pressure Calibration Offset" "-51.1766"
    Option          "Pressure Calibration Slope"  "1.7716"
EndSection

Section "InputClass"
    Identifier      "CMT for Elan Touchpad"
    MatchUSBID      "04f3:*"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"

    # default calibration values for Elan firmware
    Option          "Pressure Calibration Offset" "0.0"
    Option          "Pressure Calibration Slope"  "3.1416"

    # Devices with the default pressure calibration have a lower tap threshold
    Option          "Tap Minimum Pressure" "10.0"
EndSection

Section "InputClass"
    Identifier      "CMT for GDIX Touchpad"
    MatchUSBID      "27C6:*"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"

    Option          "Palm Pressure" "260"
    Option          "Fat Finger Pressure Ratio"  "1.0"

    # default calibration values for GDIX firmware
    Option          "Pressure Calibration Offset" "0.0"
    Option          "Pressure Calibration Slope"  "1.10"

    # Devices with the default pressure calibration have a lower tap threshold
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Trackpad"
    MatchUSBID      "05ac:030e"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
# We are using raw touch major value as pressure value, so set the Palm
# pressure threshold high.
    Option          "Palm Pressure" "1000"
    Option          "Compute Surface Area from Pressure" "0"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    # TODO(clchiou): Calibrate bias on X-axis
    Option          "Touchpad Device Output Bias on X-Axis" "-283.3226025266607"
    Option          "Touchpad Device Output Bias on Y-Axis" "-283.3226025266607"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    # Disable drumroll suppression
    Option          "Drumroll Suppression Enable" "0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Trackpad 2"
    MatchUSBID      "05ac:0265|004c:0265"
    MatchDevicePath "/dev/input/event*"

    Option          "Pressure Calibration Offset" "30"
    Option          "Palm Pressure" "250.0"
    Option          "Palm Width" "20.0"
    Option          "Multiple Palm Width" "20.0"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"
    Option          "Finger Moving Energy" "0.0008"
    Option          "Finger Moving Hysteresis" "0.0004"

    # Avoid accidental scroll/move on finger lift
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Mouse"
    MatchUSBID      "05ac:030d"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "AccelerationProfile" "-1"
    Option          "Scroll X Out Scale" "3"
    Option          "Scroll Y Out Scale" "3"
    Option          "Compute Surface Area from Pressure" "0"
    Option          "Max Allowed Pressure Change Per Sec" "170.0"
    Option          "Max Hysteresis Pressure Per Sec" "170.0"
    Option          "Max Finger Stationary Speed" "94.32"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "Box Width" "8.0"
    Option          "Box Height" "1.0"
    # Resolution overrides:
    Option          "Vertical Resolution" "40"
    Option          "Horizontal Resolution" "45"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech Wireless Touchpad"
    MatchUSBID      "046d:4011"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-313.240741792594"
    Option          "Pressure Calibration Slope" "4.39678062436752"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Palm Pressure" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T650"
    MatchUSBID      "046d:4101"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-0.439288351750068"
    Option          "Pressure Calibration Slope" "3.05998553523335"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T651"
    MatchUSBID      "046d:b00c"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-4.46520447177073"
    Option          "Pressure Calibration Slope" "3.21071719332644"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T620"
    MatchUSBID      "046d:4027"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T400"
    MatchUSBID      "046d:4026"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech Bluetooth Touchmouse"
    MatchUSBID      "046d:b00d"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech TK820"
    MatchUSBID      "046d:4102"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Touchpad Stack Version" "2"
    # Pressure jumps around a lot on this touchpad, so allow that:
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Pressure Calibration Offset" "-18.8078435"
    Option          "Pressure Calibration Slope" "2.466208137"
EndSection

Section "InputClass"
    Identifier "CMT for Stantum"
    MatchDevicePath "/dev/input/event*"
    MatchProduct    "MTP_USB_Controller"
    Driver          "cmt"
    Option          "SendCoreEvents" "On"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "IIR Distance Threshold" "1000"
    Option          "Horizontal Resolution" "8"
    Option          "Vertical Resolution" "10"
    Option          "Two Finger Scroll Distance Thresh" "0.5"
    Option          "Pressure Calibration Offset" "1.0"
    Option          "Pressure Calibration Slope" "15.0"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "Whiskers Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchUSBID    "18D1:5030"

    # Use new touchpad gesture stack
    Option          "Touchpad Stack Version" "2"
    Option          "Integrated Touchpad" "1"

    Option          "Pressure Calibration Offset" "0.0"
    Option          "Pressure Calibration Slope"  "2"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"

    Option          "Box Width" "0.5"
    Option          "Box Height" "0.5"

    # Avoid accidental scroll/move on finger lift
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"

    # Suppress clicks without fingers on the pad.
    Option          "Zero Finger Click Enable" "0"

    Option          "Filter Low Pressure" "1"
    Option          "Pinch Enable" "1"
    Option          "Palm Pressure" "220.0"
    Option          "Palm Filter Top Edge Enable" "1"
    Option          "Smooth Accel" "1"
    Option          "Tap Minimum Pressure" "20.0"

    # Touch size increases with finger count, so ignore touch size for
    # detecting palms if there are multiple touches.
    Option          "Multiple Palm Width" "200.0"
EndSection

Section "InputClass"
    Identifier      "Brydge Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchUSBID      "03F6:A001"

    Option          "Fake Timestamp Delta" "0.010"
EndSection

Section "InputClass"
    Identifier      "touchpad samus"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchProduct    "Atmel"
    Option          "Touchpad Stack Version" "2"
    Option          "Integrated Touchpad" "1"
    Option          "Pressure Calibration Offset" "-8.345256186"
    Option          "Pressure Calibration Slope" "1.006531862"
    Option          "Tap Minimum Pressure" "-15.0"
    Option          "Vertical Resolution" "8"
    Option          "Horizontal Resolution" "9"

    Option          "Palm Pressure" "120"
    Option          "Tap Exclusion Border Width" "6"
    Option          "Palm Edge Zone Width" "9"

    Option          "Pressure Minimum Threshold" "-7.84"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"
    Option          "Finger Moving Energy" "0.04"
    Option          "Finger Moving Hysteresis" "0.02"

    Option          "Box Width" "0.5"
    Option          "Box Height" "0.5"

    # Fix to prevent flings from stationary lifting fingers
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"

    Option          "Max Finger Stationary Speed" "50"

    Option          "Tap Move Distance" "3.0"
    Option          "Force Touch Count To Match Finger Count" "1"

    # Avoid palm motion
    Option          "Palm Pointing Min Move Distance" "12.0"

    # New filtering logic shouldn't apply to this platform
    Option          "Filter Low Pressure" "1"

    Option          "Pinch Enable" "1"
EndSection
TOUCHPADFIX
  else
    cat <<TOUCHPAD
# Configure touchpads to use Chromium Multitouch (cmt) X input driver
Section "InputClass"
    Identifier      "touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Tap Minimum Pressure" "0"
    Option          "AccelerationProfile" "-1"
    Option          "Scroll Buttons" "0"
    Option          "Scroll Axes" "1"

    # CMT devices potentially process keyboard events
    Option          "XkbModel" "pc"
    Option          "XkbLayout" "us"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Trackpad"
    MatchUSBID      "05ac:030e"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
# We are using raw touch major value as pressure value, so set the Palm
# pressure threshold high.
    Option          "Palm Pressure" "1000"
    Option          "Compute Surface Area from Pressure" "0"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    # TODO(clchiou): Calibrate bias on X-axis
    Option          "Touchpad Device Output Bias on X-Axis" "-283.3226025266607"
    Option          "Touchpad Device Output Bias on Y-Axis" "-283.3226025266607"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    # Disable drumroll suppression
    Option          "Drumroll Suppression Enable" "0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Trackpad 2"
    MatchUSBID      "05ac:0265|004c:0265"
    MatchDevicePath "/dev/input/event*"

    Option          "Pressure Calibration Offset" "30"
    Option          "Palm Pressure" "250.0"
    Option          "Palm Width" "20.0"
    Option          "Multiple Palm Width" "20.0"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"
    Option          "Finger Moving Energy" "0.0008"
    Option          "Finger Moving Hysteresis" "0.0004"

    # Avoid accidental scroll/move on finger lift
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"
EndSection

Section "InputClass"
    Identifier      "CMT for Apple Magic Mouse"
    MatchUSBID      "05ac:030d"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "AccelerationProfile" "-1"
    Option          "Scroll X Out Scale" "3"
    Option          "Scroll Y Out Scale" "3"
    Option          "Compute Surface Area from Pressure" "0"
    Option          "Max Allowed Pressure Change Per Sec" "170.0"
    Option          "Max Hysteresis Pressure Per Sec" "170.0"
    Option          "Max Finger Stationary Speed" "94.32"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "Box Width" "8.0"
    Option          "Box Height" "1.0"
    # Resolution overrides:
    Option          "Vertical Resolution" "40"
    Option          "Horizontal Resolution" "45"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech Wireless Touchpad"
    MatchUSBID      "046d:4011"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-313.240741792594"
    Option          "Pressure Calibration Slope" "4.39678062436752"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Palm Pressure" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T650"
    MatchUSBID      "046d:4101"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-0.439288351750068"
    Option          "Pressure Calibration Slope" "3.05998553523335"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T651"
    MatchUSBID      "046d:b00c"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Option          "Touchpad Stack Version" "1"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "Pressure Calibration Offset" "-4.46520447177073"
    Option          "Pressure Calibration Slope" "3.21071719332644"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Two Finger Vertical Close Distance Thresh" "35.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T620"
    MatchUSBID      "046d:4027"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech T400"
    MatchUSBID      "046d:4026"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech Bluetooth Touchmouse"
    MatchUSBID      "046d:b00d"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Box Width" "6"
    Option          "Box Height" "1"
    Option          "Drumroll Suppression Enable" "0"
    Option          "Input Queue Max Delay" "0.0"
    Option          "Mouse Accel Curves" "1"
    Option          "Mouse Scroll Curves" "0"
    Option          "AccelerationProfile" "-1"
    # Assume a frame interval to handle jitter on the bus
    Option          "Accel Min dt" "0.003"
EndSection

Section "InputClass"
    Identifier      "CMT for Logitech TK820"
    MatchUSBID      "046d:4102"
    MatchDevicePath "/dev/input/event*"
    Driver          "cmt"
    Option          "Touchpad Stack Version" "2"
    # Pressure jumps around a lot on this touchpad, so allow that:
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Pressure Calibration Offset" "-18.8078435"
    Option          "Pressure Calibration Slope" "2.466208137"
EndSection

Section "InputClass"
    Identifier "CMT for Stantum"
    MatchDevicePath "/dev/input/event*"
    MatchProduct    "MTP_USB_Controller"
    Driver          "cmt"
    Option          "SendCoreEvents" "On"
    Option          "IIR b0" "1"
    Option          "IIR b1" "0"
    Option          "IIR b2" "0"
    Option          "IIR b3" "0"
    Option          "IIR a1" "0"
    Option          "IIR a2" "0"
    Option          "IIR Distance Threshold" "1000"
    Option          "Horizontal Resolution" "8"
    Option          "Vertical Resolution" "10"
    Option          "Two Finger Scroll Distance Thresh" "0.5"
    Option          "Pressure Calibration Offset" "1.0"
    Option          "Pressure Calibration Slope" "15.0"
    Option          "Max Allowed Pressure Change Per Sec" "100000.0"
    Option          "Max Hysteresis Pressure Per Sec" "100000.0"
    Option          "Fling Buffer Suppress Zero Length Scrolls" "0"
EndSection

Section "InputClass"
    Identifier      "Whiskers Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchUSBID    "18D1:5030"

    # Use new touchpad gesture stack
    Option          "Touchpad Stack Version" "2"
    Option          "Integrated Touchpad" "1"

    Option          "Pressure Calibration Offset" "0.0"
    Option          "Pressure Calibration Slope"  "2"

    # Enable Stationary Wiggle Filter
    Option          "Stationary Wiggle Filter Enabled" "1"

    Option          "Box Width" "0.5"
    Option          "Box Height" "0.5"

    # Avoid accidental scroll/move on finger lift
    Option          "Max Stationary Move Speed" "47"
    Option          "Max Stationary Move Speed Hysteresis" "1"
    Option          "Max Stationary Move Suppress Distance" "0.2"

    # Suppress clicks without fingers on the pad.
    Option          "Zero Finger Click Enable" "0"

    Option          "Filter Low Pressure" "1"
    Option          "Pinch Enable" "1"
    Option          "Palm Pressure" "220.0"
    Option          "Palm Filter Top Edge Enable" "1"
    Option          "Smooth Accel" "1"
    Option          "Tap Minimum Pressure" "20.0"
EndSection

Section "InputClass"
    Identifier      "Brydge Touchpad"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    MatchUSBID      "03F6:A001"

    Option          "Fake Timestamp Delta" "0.010"
EndSection
TOUCHPAD
  fi
}

select_alt_touchpad_cmt_config() {
  local touchpad_config=""
  touchpad_config=$(get_alt_touchpad_cmt_config "$1")
  echo "$touchpad_config" > "$_ALT_TOUCHPAD_CMT_CONF"
}

current_alt_touchpad_cmt_config() {
  local real_alt_touchpad_config_path=""
  real_alt_touchpad_config_path=$(realpath "$_ALT_TOUCHPAD_CMT_CONF")
  if [[ ! -s "$real_alt_touchpad_config_path" ]]; then
    echo "0"
    return
  fi
  local _md5sum=""
  local _saved_md5sum=""
  _saved_md5sum=$(md5sum "$real_alt_touchpad_config_path" | cut -d' ' -f1)
  local content=""
  for i in {1..4}; do
    content=$(get_alt_touchpad_cmt_config "$i")
    _md5sum=$(echo "$content" | md5sum | cut -d' ' -f1)
    if [ "$_md5sum" = "$_saved_md5sum" ]; then
      echo "$i"
      return
    fi
  done
  echo "-1"
}
