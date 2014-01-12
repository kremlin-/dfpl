#!/bin/bash

# depcheck
if [ ! -e /usr/bin/xdotool ] ; then
  echo "ERROR: you do not have xdotool installed, a nessecary dependency"
  exit
fi

# vardef
sleept=0.14
winname="Dwarf Fortress"
returnk="KP_Enter"
invkey="f"
gndkey="a"
numre="^[0-9]+$"

upk="KP_Up"
downk="KP_Down"
leftk="KP_Left"
rightk="KP_Right"

# funcdefs
function throw {
  for ((c=1; c <= $num ; c++))
    do
      xdotool search --name "$winname" key t $invkey $returnk
      sleep $sleept
  done
}

function throwUsage {
  echo -e "USAGE: dfpl throw 400 s"
  echo -e "throws 400 rocks beginning with inventory slot 's'\n"
}

function pick {
  for ((c=1; c <= $num ; c++))
    do
      xdotool search --name "$winname" key g $gndkey
      sleep $sleept
  done
}

function pickUsage {
  echo -e "USAGE: dfpl pick 20 e"
  echo -e "picks up 20 rocks at ground slot 'e'\n"
}

function chat {
  for ((c=1; c <= $num ; c++))
    do
      xdotool search --name "$winname" key $returnk
      sleep $sleept
    done
}

function chatUsage {
  echo -e "USAGE: dfpl chat 200"
  echo -e "chats (presses enter) 200 times\n"
}

function stay {
  for ((c=1; c <= $num ; c++))
    do
      xdotool search --name "$winname" key period
      sleep $sleept
    done
}

function stayUsage {
  echo -e "USAGE: dfpl stay 300"
  echo -e "waits (presses period) 300 times\n"
}

function circle {
  for ((c=1; c <= $num ; c++))
    do
      xdotool search --name "$winname" key $upk
      xdotool search --name "$winname" key $rightk
      xdotool search --name "$winname" key $downk
      xdotool search --name "$winname" key $leftk
      sleep $sleept
    done
}

function circleUsage {
  echo -e "USAGE: dfpl circle 300"
  echo -e "moves in a circle 300 times\n"
}

function genUsage {
  throwUsage
  pickUsage
  chatUsage
  stayUsage
  circleUsage
  echo "see 'man dfpl' for more information"
}

# handle flags
OPTS=`getopt -o fs:w:r:v --long sleep:,winname:,return-keysym:,version,fast -- "$@"`
if [ $? != 0 ] ; then
  exit 1
fi

eval set -- "$OPTS"

while true ; do
  case "$1" in
    -v|--version) echo "version 0.1"; exit; shift;;
    -s|--sleep) sleept=$2; shift 2;;
    -w|--winname) winname=$2; shift 2;;
    -r|--return-keysym) returnk=$2; shift 2;;
    -f|--fast) sleept=0.04; shift;;
    --) shift; break;;
  esac
done

# run
if [ "$1" == "throw" ] ; then
  if ! [[ $2 =~ $numre ]] ; then
    echo -e "error: need integer"
    throwUsage
  else
    num=$2
    if [[ -n "$3" ]] ; then
      invkey=$3
    fi
    throw
  fi
elif [ "$1" == "pick" ] ; then
  if ! [[ $2 =~ $numre ]] ; then
    echo -e "error: need integer"
    pickUsage
  else
    num=$2
    if [[ -n "$3" ]] ; then
      gndkey=$3
    fi
    pick
  fi
elif [ "$1" == "chat" ] ; then
  if ! [[ $2 =~ $numre ]] ; then
    echo -e "error: need integer"
  else
    num=$2
    chat
  fi
elif [ "$1" == "stay" ] ; then
  if ! [[ $2 =~ $numre ]] ; then
    echo -e "error: need integer"
    stayUsage
  else
    num=$2
    stay
  fi
elif [ "$1" == "circle" ] ; then
  if ! [[ $2 =~ $numre ]] ; then
    echo -e "error: need integer"
    circleUsage
  else
    num=$2
    circle
  fi
else
  echo -e "syntax error\n"
  genUsage
fi
