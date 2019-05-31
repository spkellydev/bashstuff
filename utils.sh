#!/bin/bash

function mkcd() {
  mkdir -p $1 && cd $1;
}
function projs() {
  cd ~/Projects;
}

function gethosts() {
  if [[ $1 ]]; then
     cat /c/Windows/System32/drivers/etc/hosts | grep "$1" -A 2
  else
     cat /c/Windows/System32/drivers/etc/hosts
  fi

}

# Open WAR
function war() {
  pushd ~/Documents/WAR > /dev/null;
  DATE=`date -d 'this Friday' '+%Y%m%d'`
  EXCEL="$DATE JMOS-RRFIS-RMCE Weekly Activity Report (WAR) Kelly, Sean.xlsx"
  cp -n WAR.xlsx "$EXCEL" > /dev/null
  start excel "$EXCEL"
  popd > /dev/null
}
