#!/bin/bash


# ============= Function definitions ===============

# Function for updating gpio pin
function updateGPIO {
  adb shell "echo 31 > /sys/class/gpio/export"
  adb shell "echo out > /sys/class/gpio/gpio31/direction"
  adb shell "echo $1 > /sys/class/gpio/gpio31/value"
}


# =================================================


# Checking arguments
if [[ -z "$1" ]]
then
  echo "You must pass the package name as an argument before proceding."
  echo "Example: ./rerun.sh org.mozilla.focus"
  exit
fi

check_installed=$(adb shell pm list packages | grep $1)

if [[ -z "$check_installed" ]]
then
  echo "The package ($1) is not currently installed in the device"
  exit
fi


# define the core on which the collection should take place
# selecting a little core
core="/system/bin/taskset 02" 

echo "Moving mouse to upper right corner"
#adb push upperRight /data/iDVFS/RERAN/"
adb shell "$core /data/iDVFS/RERAN/bin/replay.exe /data/iDVFS/RERAN/upperRight"



## checking if we should enable energy measurement
## we can pass anything as a second argument in order to enable measurement
if [[ ! -z "$2" ]]; then
  echo "Enabling energy measurement"
  updateGPIO 0
fi

echo "Reproducing moviments for configuration: $1"
adb shell "$core /data/iDVFS/RERAN/bin/replay.exe /data/iDVFS/RERAN/logs/trans-${1}"


if [[ ! -z "$2" ]]; then
  echo "Disabling energy measurement"
  updateGPIO 1
fi



echo ""
echo ""
echo "Done with reproduction"
