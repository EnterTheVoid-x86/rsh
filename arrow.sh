#!/bin/bash
printf "Setting prompt arrow to lambda. Preview: 
\n[runner@d7bf2abcc65b]-(/home/runner/Ruby-Linux-Shell-1/ruby-shell)
↳"
sleep 1
rm -rf config.yml
printf "prompt: '↳ '
message: 'Welcome to Ruby Shell v1.25!'
ascii: 'logo.txt'"  >> config.yml
printf "\nFinished."
sleep 1
printf "\n"
exec ruby main.rb