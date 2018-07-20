#!/bin/bash


## ref: http://www.androidreran.com/software.php

mkdir -p logs

if [[ -z "$1" ]]
then
  echo "You must pass the package name as an argument before proceding."
  echo "Example: ./collect.sh org.mozilla.focus"
  exit
fi

check_installed=$(adb shell pm list packages | grep $1)

if [[ -z "$check_installed" ]]
then
  echo "The package ($1) is not currently installed in the device"
  exit
fi


outFile=$1


function ctrl_c() {
   echo ""
   echo "Stopping sample collection"
}

trap ctrl_c INT



# collect moviments
echo "Moving mouse to upper right corner"
#adb push upperRight /data/iDVFS/RERAN/"
adb shell "/data/iDVFS/RERAN/bin/replay.exe /data/iDVFS/RERAN/upperRight"

echo ""
echo ""
echo "Collecting mouse moviments - press control C to stop"
adb shell getevent -tt > logs/$outFile

echo "Translating original events to RERAN"
java -cp bin Translate logs/$outFile logs/trans-${outFile}

echo "Moving RERAN translated file to device"
adb push logs/trans-${outFile} /data/iDVFS/RERAN/logs


echo "Done"
#adb shell "/data/iDVFS/RERAN/bin/replay.exe /data/iDVFS/RERAN/logs/trans-${outFile}"
