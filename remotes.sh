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

# Remote Desktop Connection
function rdp() {
  ARGS=
  if [[ $1 ]]; then
    # Create the connection file name, uppercase is important
    REMOTE="$(echo $1 | tr a-z A-Z).rdp"
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
