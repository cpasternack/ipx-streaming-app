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
  AUDIOSTREAM=$2
else
  echo "No audio stream named."
  exit 2
fi

if [ ! -z "$3" ]
then
  AUDIORATE=$3
else
  AUDIORATE="64k"
fi

if [ ! -z "$3" ]
then
  MAXRATE=$3
else
  MAXRATE="96k"
fi

if [ ! -z "$5" ]
then
  BUFFSIZE=$5
else
  BUFFSIZE="128k"
fi

if [ ! -z "$6" ]
then
  AUDIOSOURCE=$6
else
  AUDIOSOURCE=default
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
FFMPEGAUDIOPIDFILE=$HOME/rtsp/"$APPLICATION"_ffmpeg_audio_stream.pid

# fix encoding/transmission mis-match
AUDIORATEN=`echo | cut -c -"$((${#AUDIORATE}-1))"` # numeric value (minus-k/m)
MAXRATEN=`echo | cut -c -"$((${#MAXRATE}-1))"` # numeric value (minus-k/m)

if [ $MAXRATEN -lt $AUDIORATEN ]
then
  MAXRATEN=$(($AUDIORATEN*2)) #maxrate is twice the audio rate
  MAXRATE="$MAXRATEN"k
fi

function start_streaming_audio()
{
  # grab pulse audio on $AUDIOSOURCE and convert to aac $AUDIORATE
  FFMPEGAUDIOPID=$(ffmpeg -nostdin -f pulse -i $AUDIOSOURCE -c:a aac -b:a $AUDIORATE -strict -2 -maxrate $MAXRATE -bufsize $BUFFSIZE -f rtsp rtsp://$IP_OUT:$PORT/$AUDIOSTREAM) \
    && echo $FFMPEGAUDIOPID > $FFMPEGAUDIOPIDFILE
}

function stop_streaming_audio()
{
  FFMPEGAUDIO=`cat $FFMPEGAUDIOPIDFILE`
  kill -TERM $FFMPEGAUDIO
  if [ -f "$FFMPEGAUDIOPIDFILE" ]
  then
    rm $FFMPEGAUDIOPIDFILE
  fi
}

# get the process of application 
PROCESS=`pidof $APPLICATION`

while true 
do
  if [ ! -z "$PROCESS" ]
  then
    start_streaming_audio 
    echo "broadcasting $PROCESS $APPLICATION audio on rtsp://$IP_OUT:$PORT/$AUDIOSTREAM"
    sleep 1m 
    PROCESS=`pidof $APPLICATION`
  elif [ -z "$PROCESS" ]
  then
    stop_streaming_audio
    echo "stopping broadcasting of $APPLICATION audio on rtsp://$IP_OUT:$PORT/$AUDIOSTREAM"
    sleep 1m
    PROCESS=`pidof $APPLICATION`
  else
    break
  fi
done

exit $?
