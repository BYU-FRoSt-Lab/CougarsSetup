#!/bin/bash

CONTROL_ID="15569680"

cd ~/teensy_ws/control/.pio/build/teensy41
tycmd upload --board $SENSOR_ID firmware.hex
