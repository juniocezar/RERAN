#!/bin/bash


## ref: http://www.androidreran.com/software.php

mkdir -p logs
outFile=recordedEvents.txt

if [[ ! -z "$1" ]]
then
  outFile=$1
fi

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
