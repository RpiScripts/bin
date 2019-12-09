#!/bin/bash

let TIMELAPSE=$1*60

ediplug.sh ON
sleep $TIMELAPSE
ediplug.sh OFF
