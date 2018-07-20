#!/bin/bash


if [[ -z "$1" ]]; then
  echo "You must pass the configuration file as argument"
  exit
fi

# define the core on which the collection should take place
# selecting a little core
core="/system/bin/taskset 02" 

echo "Moving mouse to upper right corner"
#adb push upperRight /data/iDVFS/RERAN/"
adb shell "$core /data/iDVFS/RERAN/bin/replay.exe /data/iDVFS/RERAN/upperRight"

echo "Reproducing moviments for configuration: $1"
adb shell "$core /data/iDVFS/RERAN/bin/replay.exe /data/iDVFS/RERAN/logs/trans-${1}"


echo ""
echo ""
echo "Done with reproduction"
