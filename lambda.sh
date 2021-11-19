#!/bin/bash
echo "Setting prompt arrow to lambda. Preview: [runner@d7bf2abcc65b]-(/home/runner/Ruby-Linux-Shell-1/ruby-shell)
λ"
sleep 0.5
rm -rf config.yml
printf "prompt: 'λ '
message: 'Welcome to Ruby Shell v1.2'" >> config.yml
echo "Finished."
exec ruby main.rb