#!/bin/bash

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.


#Version info 
VERSION='1.0'
#set url and port to the xbmc box webservice
XBMC_HOST="http://192.168.1.41:80"


#run this with curl....?
function execute {
  payload=$1
  ##remove -s -o /dev/null to see server responses...
  curl -u xbmc:password -d "$payload" -H "Content-type:application/json" -X POST "${XBMC_HOST}/jsonrpc" -s -o /dev/null

}


##open a url
function readURL {
  if [ "$1" = "" ]; then
  echo -n "Insert URL: "
  read url
  else
  url="$1"
  fi
  
  if [[ "$url" == *youtube.com* ]]
  then
    vid=$( echo "$url" | tr '?&#' '\n\n' | grep -e '^v=' | cut -d'=' -f2 )
    payload='{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item": {"file" : "plugin://plugin.video.youtube/?action=play_video&videoid='$vid'" }}, "id" : "1"}'
  elif [[ "$url" == *vimeo.com* ]]
  then
    vid=$( echo "$url" | awk -F"/" '{print ($(NF))}' )
    payload='{"jsonrpc": "2.0", "method": "Player.Open", "params":{"item": {"file" : "plugin://plugin.video.vimeo/?action=play_video&videoid='$vid'" }}, "id": "1" }'
  else
    payload='{ "jsonrpc": "2.0", "method": "Player.Open", "params": { "item": { "file": "'${url}'" }}, "id": 1 }'
  fi
  
  #echo $payload
  execute "$payload"
}
##pause/resume 
function pauseResume {
  echo "pausing/resuming"
   # payload='{ "jsonrpc": "2.0", "method": "Player.GetActivePlayers", "id": 1}'
    #echo $payload
   # execute "$payload"
    
    payload='{ "jsonrpc": "2.0", "method": "Player.PlayPause",  "params": { "playerid": 1 }, "id": 1}'
  
  
  #echo $payload
  execute "$payload"
}

function moveup {
  echo "up"
  execute '{ "jsonrpc": "2.0", "method": "Input.Up", "id": 1}'
}
function movedown {
  echo "down"
  execute '{ "jsonrpc": "2.0", "method": "Input.Down", "id": 1}'
}
function moveleft {
  echo "left"
  execute '{ "jsonrpc": "2.0", "method": "Input.Left", "id": 1}'
}
function moveright {
  echo "right"
  execute '{ "jsonrpc": "2.0", "method": "Input.Right", "id": 1}'
}
function Iselect {
  echo "select"
  execute '{ "jsonrpc": "2.0", "method": "Input.Select", "id": 1}'
}
function IBack {
  echo "back"
  execute '{ "jsonrpc": "2.0", "method": "Input.Back", "id": 1}'
}


function usage {
  echo 
  echo
  echo "#######xbmc script########"
  echo "usage:"
  echo "o: open file or stream"
  echo "p: pause/resume playing"
  echo "[awsd] to move around"
  echo "g: select"
  echo "h: back"
  echo "v: show Version"
  echo "?: show usage"
  echo "q: quit"
  echo
  echo
  
}
#start actual script

#start URL if supplied as argument.
if [ "$1" != "" ]; then
  readURL $1
fi

usage
while read -s -n 1 command; do
#usage


case "$command" in
  'o') readURL ;;
  'p') pauseResume ;;
  'a') moveleft ;;
  'w') moveup ;;
  's') movedown ;;
  'd') moveright ;;
  'g') Iselect ;;
  'h') IBack ;;
  'v') echo "Script-Version: $VERSION";;
  '?') usage ;;
  'q') echo "quitting"; exit;;
        
esac

#echo $1

done;
  



