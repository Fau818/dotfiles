#!/usr/bin/env sh

# NOTE: Show the battery percentage of the AirPods and AirPods Case
AIRPODSBATTERY=$(system_profiler SPBluetoothDataType | grep 'Left Battery\|Right Battery' | awk '{printf $4}' | awk '{printf $1+$2}')
AIRPODICON=􀪷

if [[ $AIRPODSBATTERY = "" ]]; then
	sketchybar --set $NAME icon=$AIRPODICON label="not connected |"
else
	sketchybar --set $NAME icon=$AIRPODICON label="$AIRPODSBATTERY% |"
fi


#!/usr/bin/env sh

AIRPODSCASEBATTERY=$(system_profiler SPBluetoothDataType | grep 'Case Battery' | awk '{print $4}')
AIRPODCASE="􀹫  􀹬 "

if [[ "$AIRPODSCASEBATTERY" = "" ]]; then
	sketchybar --set $NAME icon=$AIRPODCASE label="not detected"
else
	sketchybar --set $NAME icon=$AIRPODCASE label="$AIRPODSCASEBATTERY "
fi
