#!/usr/bin/env ruby

system "clear"
system "tput civis"

begin
  loop do
    print Time.new.strftime("%I:%M:%S %p")
    sleep 1
    system "clear"
rescue Interrupt
  system "clear"
  system "tput cnorm"
  exit
end
end