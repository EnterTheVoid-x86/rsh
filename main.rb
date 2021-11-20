#!/usr/bin/env ruby

# Ruby Shell v1.25
require 'readline'
require 'shellwords'
require 'socket'
require 'etc'
require "yaml"

require_relative 'modules/colors.rb'

config = YAML.load_file('config.yml')
workingdir = Dir.pwd

# Defines the system function to call system commands

def system(command)
  pid = fork {
    exec(command)
  }
  Process.wait pid
end

def print_exception(exception, explicit)
  puts "[#{explicit ? 'EXPLICIT' : 'INEXPLICIT'}] #{exception.class}: #{exception.message}"
  puts exception.backtrace.join("\n")
end

# Defines build-in commands

builtin = {
  'cd' => lambda { |dir|
    if dir == "~"
      Dir.chdir(File.expand_path('~'))
    else
      Dir.chdir(dir)
    end
  },
  '..' => lambda { Dir.chdir("../") },
  'exit' => lambda { |code = 0| exit(code.to_i) },
  'exec' => lambda { |*com| exec *com },
  'history' => lambda {
    puts Readline::HISTORY.to_a
  },
  'set' => lambda { |args|
   key, value = args.split('=')
   ENV[key] = value
  }
}

# Loads the color module on class String
# Used to color strings ¯\_(ツ)_/¯

class String
  include Colors
end

# ascii art from ann1kab, thanks by the way!
def render_ascii_art(string)
  File.readlines(string) do |line|
    puts line
  end
end

# Put the warning inside README.md
puts render_ascii_art(config['ascii'])
sleep 1

puts config['message'].blink.red

begin
  while input = Readline.readline("[#{Etc.getlogin}@#{Socket.gethostname}]-(#{Dir.pwd})\n#{config['prompt']}", true).strip # broken prompt is finally fixed

    comp = proc do |s|
      directory_list = Dir.glob("#{s}*")
      if directory_list.size > 0
        directory_list
      else
        Readline::HISTORY.grep(/^#{Regexp.escape(s)}/)
      end
    end

    Readline.completion_append_character = " "
    Readline.completion_proc = comp

    com, *arg = Shellwords.shellsplit(input)

    begin
      if builtin[com]
        builtin[com].call(*arg)
      elsif input == ""
        Readline::HISTORY.pop
      else
        input = input.chars
        if input[0].eql?("l") and input[1].eql?("s")
          input.insert(2, " --color")
        end
        input = input.join
        #puts input
        system(input)
      end
    rescue ArgumentError => e
      if input == "cd"
        Dir.chdir(File.expand_path('~')) # Removed cd error
      else
        print_exception(e, true)
      end
    end

  # Writes the history to a history file
  # The shell is currently ABLE to load this file, but only for the commands ran in the current session, once restarted, it doesn't work, and creates a loop of this bug.

    begin
      file = File.open("#{workingdir}/history.txt", "a+")
      file.write("#{Readline::HISTORY.to_a.last}\n")
    rescue IOError => e
      #some error occur, dir not writable etc.
      puts "Failed to open file."
    ensure
      file.close unless file.nil?
    end
  end
  # ah yes, stolen stackoverflow code, my favorite
rescue Interrupt => e
  # Ensuring that the shell still gets executed if interrupted
  puts "^C"
  retry
rescue NoMethodError => d
  puts "Quitting...".red
  sleep 0.2
rescue SystemExit => f 
  puts "Quitting...".red
  sleep 0.2
end