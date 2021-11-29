#!/bin/bash
end=$((SECONDS+3))
printf "Setting prompt symbol to ^-s>, made for Spock. Preview: \n
[runner@d7bf2abcc65b]-(/home/runner/)
^-s> "
sleep 2
rm -rf config.yml
i=1
sp="/-\|_"
echo -n ' '
while [ $SECONDS -lt $end ]
do
    printf "\b${sp:i++%${#sp}:1}"
done
printf "prompt: '^-s> '
message: 'Welcome to Spock.'
ascii: 'logo.txt'"  >> config.yml
printf "\nFinished."
sleep 1
printf "\n"
exec ruby main.rb