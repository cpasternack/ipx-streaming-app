#!/usr/bin/env bash


if [ ! -z "$1" ]
then
  APPLICATION=$1
else
  echo "No application specified."
  exit 1
fi

if [ ! -z "$2" ]
then
  
else
  echo "No video sink specified."
  exit 2
fi

if [ ! -z "$3" ]
then
  OUTPUTFORMAT=$3
else
  OUTPUTFORMAT="raw"
fi

if [ ! -z "$4" ]
then
  OUTPUTCONVERT=$4
else
  OUTPUTCONVERT=""
fi
if [ ! -z "$1" ]
then
  export DISPLAY=$1
else
  export DISPLAY=:0.0
fi

GAMEREPLAY="`date +%Y%m%d%H%M%S%Z`.mkv"
REPLAYDIR=$HOME/rtsp

GSTPIDVIDEOFILE=$HOME/rtsp/"$APPLICATION"_gst_launch.pid

function start_video_capture()
{
  # determine the xid of wine desktop application, and send to /dev/video0 with gstreamer
  XID=`wmctrl -l | grep "Wine desktop" | cut -c -10`
  echo "Found Wine Desktop on $XID" 
  echo $XID >$HOME/rtsp/desktop.xid
  if [ "$OUTPUTSINK" == "REPLAY" ]
  then
    # sink to matroska video file
    # test
    gst-launch-1.0 -vvv ximagesrc xid=$XID ! videoconvert ! "video/x-raw,format=YUY2" ! autovideosink 
  fi
  
  gst-launch-1.0 -vvv ximagesrc xid=$XID ! videoconvert ! "video/x-raw,format=YUY2" ! tee ! v4l2sink device=/dev/video0
  # test output
  #gst-launch-1.0 -vvv ximagesrc xid=$XID ! videoconvert ! "video/x-raw,format=YUY2" ! autovideosink 
  #gst-launch-1.0 videotestsrc ! videoconvert ! autovideosink
  #gst-inspect-1.0
  echo $! >$GSTPIDVIDEOFILE
}

function stop_video_capture()
{
  GSTVIDEO=`cat $GSTVIDEOFILE`
  kill -2 $GSTVIDEO
}

IPIF="ens3"
IP_OUT=`ip addr show $IPIF | grep -Po 'inet \K[\d.]+'`
PORT=8554

# get the process of bomberman.exe
PROCESS=`pidof bomberman.exe`

set -x
while true 
do
  if [ ! -z "$PROCESS" ]
  then
    start_video_capture 
    echo "sending x11 window to /dev/video0"
    sleep 1m
    PROCESS=`pidof bomberman.exe`
  elif [ -z "$PROCESS" ]
  then
    stop_video_capture
    echo "stopping capture of x11 video on $XID" 
    sleep 1m
    PROCESS=`pidof bomberman.exe`
  else
    break
  fi
done
exit $?
