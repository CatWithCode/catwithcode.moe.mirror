#!/bin/bash

# For OpenComposite, sould SteamVR not work:
#VR_OVERRIDE=/run/host/usr/share/opencomposite XR_RUNTIME_JSON=/run/host/usr/share/openxr/1/openxr_monado.json PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%

# VR-SafeMode-CleanUp (https://linuxhint.com/replace_string_in_file_bash/):

# - Assign the filename
filename="/home/###YOUR_USERNAME###/.steam/steam/config/steamvr.vrsettings"

# - Take the search string
search="\"blocked_by_safe_mode\" : true"

# - Take the replace string
replace="\"blocked_by_safe_mode\" : false"

# - Replacing String:
if [[ $search != "" && $replace != "" ]]; then
  sed -i "s/$search/$replace/" $filename
fi

# Start Steam:

export STEAMVR_PATH="~/.local/share/Steam/steamapps/common/SteamVR"

export STEAM_RUNTIME=~/.steam/root/ubuntu12_64/steam-runtime

export XDG_SESSION_TYPE=x11
export QT_QPA_PLATFORM=xcb

export -n XDG_BACKEND
export -n ELM_ENGINE
export -n ELM_DISPLAY
export -n WINIT_UNIX_BACKEND
export -n BEMENU_BACKEND
export -n SDL_VIDEODRIVER
export -n ECORE_EVAS_ENGINE
export -n CLUTTER_BACKEND
export -n QT_WAYLAND_DISABLE_WINDOWDECORATION
export -n QT_WAYLAND_FORCE_DPI

export STEAMVR_EMULATE_INDEX_CONTROLLER=1 
STEAMVR_EMULATE_INDEX_CONTROLLER=1
~/.steam/steam/steamapps/common/SteamVR/bin/vrstartup.sh