#!/usr/bin/env ruby

require_relative 'modules/colors.rb'

class String
  include Colors
end

puts "Loading Ruby Shell v1.34...".blink.red
sleep 0.5
exec "ruby rsh"
