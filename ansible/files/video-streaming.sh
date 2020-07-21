#!/usr/bin/env bash

set -x

if [ ! -z "$1" ]
then
  APPLICATION=$1
else
  echo "No application specified."
  exit 1
fi

if [ ! -z "$2" ]
then
  VIDEOSTREAM=$2
else
  echo "No video stream named."
  exit 2
fi

if [ ! -z "$3" ]
then
  VIDEORATE=$3
else
  VIDEORATE="500k"
fi

if [ ! -z "$4" ]
then
  BUFFSIZE=$4
else
  BUFFSIZE="1000k"
fi

if [ ! -z "$5"]
then
  export DISPLAY=$3
else
  DISPLAY=:0.0
fi

if [ ! -z "$6" ]
then
  VIDEOSOURCE=$6
else
  VIDEOSOURCE=/dev/video0
fi

if [ ! -z "$7" ]
then
  IPIF=$7
else
  IPIF="ens3"
fi

if [ ! -z "$8" ]
then
  PORT=$8
else
  PORT=8554
fi

IP_OUT=`ip addr show $IPIF | grep -Po 'inet \K[\d.]+'`
FFMPEGVIDEOPIDFILE=$HOME/rtsp/"$APPLICATION"_ffmpeg_video_stream.pid

function start_streaming_video()
{
  #ffmpeg -f x11grab -video_size cif -framerate 30 -i $DISPLAY -f rtsp rtsp://$IP_OUT:$PORT/$APPLICATION
  FFMPEGVIDEOPID=$(ffmpeg -f v4l2 -input_format yuyv422 -r 30 -i $VIDEOSOURCE -vf format=yuv420p -c:v libx264 -crf 25 -maxrate $VIDEORATE -bufsize $BUFFSIZE -f rtsp rtsp://$IP_OUT:$PORT/$VIDEOSTREAM) \
  && echo $FFMPEGVIDEOPID >$FFMPEGVIDEOPIDFILE
}

function stop_streaming_video()
{
  FFMPEGVIDEO=`cat $FFMPEGVIDEOPIDFILE`
  kill -TERM $FFMPEGVIDEO
  if [ -f "$FFMPEGVIDEOPIDFILE" ]
  then
    rm $FFMPEGVIDEOPIDFILE
  fi
}

# get the process of $APPLICATION
PROCESS=`pidof $APPLICATION`

while true 
do
  if [ ! -z "$PROCESS" ]
  then
    start_streaming_video 
    echo "broadcasting $PROCESS $APPLICATION video from $DISPLAY on rtsp://$IP_OUT:$PORT/$VIDEOSTREAM"
    sleep 1m
    PROCESS=`pidof $APPLICATION`
  elif [ -z "$PROCESS" ]
  then
    stop_streaming_video
    echo "stopping broadcasting of $APPLICATION video from $DISPLAY on rtsp://$IP_OUT:$PORT/$VIDEOSTREAM" 
    sleep 1m
    PROCESS=`pidof $APPLICATION`
  else
    break
  fi
done
exit $?
