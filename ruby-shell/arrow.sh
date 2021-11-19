#!/bin/bash
echo "Reverting prompt arrow back to original. Preview: [runner@d7bf2abcc65b]-(/home/runner/Ruby-Linux-Shell-1/ruby-shell)
↳"
sleep 0.5
rm -rf config.yml
printf "prompt: '↳ '
message: 'Welcome to Ruby Shell v1.2'" >> config.yml
echo "Finished."
exec ruby main.rb