#!/bin/bash

g_desktop_pos=$1
readonly g_desktop_pos

declare -A g_xrandr_res
g_xrandr_res["qhd_1"]="2560x1440"
g_xrandr_res["qhd_2"]="2560x1440"
readonly g_xrandr_res

declare -A g_xrandr_rate
g_xrandr_rate["qhd_1"]="33.00"
g_xrandr_rate["qhd_2"]="30.00"
readonly g_xrandr_rate

declare -A g_xrandr_mode
g_xrandr_mode["qhd_1"]="${g_xrandr_res["qhd_1"]}_${g_xrandr_rate["qhd_1"]}"
g_xrandr_mode["qhd_2"]="${g_xrandr_res["qhd_2"]}_${g_xrandr_rate["qhd_2"]}"
readonly g_xrandr_mode

declare -A g_xrandr_args
g_xrandr_args["qhd_1"]="162.77  2560 2688 2960 3360  1440 1441 1444 1468  -HSync +Vsync"
g_xrandr_args["qhd_2"]="146.27  2560 2680 2944 3328  1440 1441 1444 1465  -HSync +Vsync"
readonly g_xrandr_args

for mode in ${!g_xrandr_mode[@]}; do
  #Create new mode, and if it fails
  xrandr --newmode ${g_xrandr_mode[${mode}]} ${g_xrandr_args[${mode}]}
  #Add mode, to hdmi output
  xrandr --addmode HDMI-1 "${g_xrandr_mode[${mode}]}"
  #Enable mode on hmdi output
  if [ "${g_desktop_pos}" == "left" ]; then
    if xrandr --output LVDS-1 --mode 1366x768 --pos 2560x672 --rotate normal \
           --output DP-1 --off \
           --output HDMI-1 --primary --mode ${g_xrandr_mode[${mode}]} --pos 0x0 --rotate normal \
           --output VGA-1 --off
    then
      #break on success 
      break
    fi
  elif [ "${g_desktop_pos}" == "right" ]; then
    if xrandr --output LVDS-1 --mode 1366x768 --pos 0x672 --rotate normal \
           --output DP-1 --off \
           --output HDMI-1 --primary --mode ${g_xrandr_mode[${mode}]} --pos 1366x0 --rotate normal \
           --output VGA-1 --off
    then
      #break on success 
      break
    fi
  fi
done

exit 0

if xrandr --newmode "2560x1440_33.00"  162.77  2560 2688 2960 3360  1440 1441 1444 1468  -HSync +Vsync ; then

  xrandr --addmode HDMI-1 "2560x1440_33.00"
  xrandr --output LVDS-1 --mode 1366x768 --pos 2560x672 --rotate normal \
         --output DP-1 --off \
         --output HDMI-1 --primary --mode 2560x1440_33.00 --pos 0x0 --rotate normal \
         --output VGA-1 --off

elif xrandr --newmode "2560x1440_30.00"  146.27  2560 2680 2944 3328  1440 1441 1444 1465  -HSync +Vsync ; then
  xrandr --addmode HDMI-1 "2560x1440_30.00"
  xrandr --output LVDS-1 --mode 1366x768 --pos 2560x672 --rotate normal \
         --output DP-1 --off \
         --output HDMI-1 --primary --mode 2560x1440_30.00 --pos 0x0 --rotate normal \
         --output VGA-1 --off
fi

