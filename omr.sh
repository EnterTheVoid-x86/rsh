#!/bin/bash
printf "Welcome to Oh My RSH, the all in one prompt changer."
  sleep 0.5
printf "\nPlease select which prompt symbol you want to choose."
  sleep 0.5
printf "\n1: Default"
  sleep 0.5
printf "\n2: Lambda"
  sleep 0.5
printf "\n3: ~$ aka Fish Prompt"
  sleep 0.5
printf "\nPress Control + C to exit."
  read promptsettings

if [ $promptsettings == 1 ]
  then
    sleep 0.5
    exec bash arrow.sh
elif [ $promptsettings == 2 ]
  then
    sleep 0.5
    exec bash lambda.sh
elif [ $promptsettings == 3 ]
  then
    sleep 0.5   
    exec bash fishprompt.sh
else 
  printf "\nSorry, that wasn't a choice. Please select from one of the choices again."
  sleep 0.5
  exec bash OhMyRS.sh
fi