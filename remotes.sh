#!/bin/bash

# Dump the vsphere creds
function vsphere() {
  if [[ $1 == 'info' ]]; then
    cat ~/Documents/Locker/Info/vsphere
  else
    vsphere_path="/c/Program Files (x86)/VMware/Infrastructure/Virtual Infrastructure Client/Launcher"
    ("$vsphere_path"/VpxClient.exe&) &> /dev/null
  fi
}

function openrdp() {
  mstsc "$@" &
}

function rrfis_rdp() {
  local CHOICE=
  PS3='Which RRFIS system do you need? '
  options=("Primary (default)" "Secondary")
  select opt in "${options[@]}"
  do
    case $opt in
      "Primary")
        CHOICE="primary"
        break
        ;;
      "Secondary")
        CHOICE="secondary"
        break
        ;;
      *) CHOICE="primary"
        break
        ;;
    esac
  done
  echo $CHOICE
}

# Remote Desktop Connection
function rdp() {
  ARGS=
  if [[ $1 ]]; then
    SSYS="$(echo $1 | tr a-z A-Z)"
    if [[ $SSYS == 'RRFIS' ]]; then
      SSYS="RRFIS-$(rrfis_rdp)"
      echo "$SSYS"
    fi
    # Create the connection file name, uppercase is important
    REMOTE="$SSYS.rdp"
    RDP_CONNECTIONS=~/Documents/Locker/Info/rdp
    pushd -- $RDP_CONNECTIONS > /dev/null
    if [[ -f "$RDP_CONNECTIONS/$REMOTE" ]]; then
      ARGS="$RDP_CONNECTIONS/$REMOTE"
    else
      echo "No $REMOTE file has been saved to $RDP_CONNECTIONS, consider saving an rdp file to that path"
      ARGS=
    fi
    popd > /dev/null
  fi

  openrdp $ARGS
}
