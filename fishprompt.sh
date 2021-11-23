#!/bin/bash
end=$((SECONDS+3))
printf "Setting prompt symbol to ~$, also known as the Fish Shell Prompt. Preview: \n
[runner@d7bf2abcc65b]-(/home/runner/Ruby-Linux-Shell-1/ruby-shell)
~$"
sleep 2
rm -rf config.yml
i=1
sp="/-\|_"
echo -n ' '
while [ $SECONDS -lt $end ]
do
    printf "\b${sp:i++%${#sp}:1}"
done
printf "prompt: '~$ '
message: 'Welcome to Ruby Shell v1.32!'
ascii: 'logo.txt'"  >> config.yml
printf "\nFinished."
sleep 1
printf "\n"
exec ruby main.rb