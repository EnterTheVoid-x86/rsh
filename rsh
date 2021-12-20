#!/usr/bin/env ruby

# Ruby Shell v1.38
# Written by Stargirl-chan
# Modified and maintained by EnterTheVoid-x86
require 'readline'
require 'shellwords'
require 'socket'
require 'etc'
require "yaml"


time = Time.new




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
  'amongus' => lambda {
    puts "in real life".blink.red
    sleep 0.4
    puts "sus".blink.red
    sleep 0.4
    puts "sus".blink.red
  },
  'lambda' => lambda {
    puts "No, it's not a reference to Half-Life."
  },
  'cls' => lambda {
    puts "\e[H\e[2J"
  },
  'beep' => lambda {
    puts 7.chr, "Beep!"
  },
  'inf' => lambda {
    puts "Ruby Shell v1.37".blink.red
    printf "Powered by Ruby v3.03".blink.red
    puts "\nMaintained by", "EnterTheVoid-x86".blink.green
    printf "\nCreated 2020, current version was released on November 24th, 2021.\n".blink.magenta
  },
  'info' => lambda {
    puts "Ruby Shell v1.37".blink.red
    printf "Powered by Ruby v3.03".blink.red
    puts "\nMaintained by", "EnterTheVoid-x86".blink.green
    printf "\nCreated 2020, current version was released on November 26th, 2021.\n".blink.magenta
  },
  'time' => lambda {
    puts "The time is:", time.strftime("%I:%M %p.") 
  },
  'date' => lambda {
    puts "Today is:", time.strftime("%m/%d/%Y.") 
  },
  'unixtime' => lambda {
    puts "Unix time as of right now is:", time.strftime("%s.")
  },
  'europedate' => lambda {
    puts time.strftime("%d/%m/%Y")
  },
  # For all you Europeans out there, here's your dates in day, month, year format
  '24hr' => lambda {
    puts time.strftime("%k:%M")
  }, # The time doesn't get a break either.
  'set' => lambda { |args|
   key, value = args.split('=')
   ENV[key] = value
  },
  'help' => lambda {
    puts "rsh: commands:"
    printf "\ninf, info: prints info about the shell"
    printf "\ntime, 24hr: prints the current time"
    printf "\ndate, europedate: prints the current date"
    printf "\ncls, clear: clears the screen"
    printf "\nunixtime: prints the current time in unix timestamps"
    printf "\nbeep: beep beep motherfu-\n"
    printf "rps, rockpaperscissors: play a game of rock paper scissors\n"
    printf "all regular bash commands are also in the shell, such as cd and exit.\n"
  },
  ';' => lambda {
    puts "Dude, get out of here, this isn't Java." 
    sleep 1
  },
  'calc' => lambda {
    exec("./calc")
  },
  'calculator' => lambda {
    exec("./calc")
  },
  'NUCLE198511' => lambda {
    puts "\e[H\e[2J"
    sleep 1
    puts 7.chr 
    sleep 1
    puts 7.chr
    sleep 3
    puts 7.chr
    puts "The Wall of Credits".red
    sleep 2
    puts "Stargirl-chan, made the shell".red
    sleep 2
    puts "EnterTheVoidx86, created the best fork".blink.green
    sleep 2
    puts "Ann1kaB, made the ASCII art module".blue
    sleep 2
    puts "Thanks for using Ruby Shell.".blink.red
    sleep 7
    puts "https://soundcloud.com/nucleus408/".blink.green
    sleep 2
    puts "\e[H\e[2J"
  },
  'rps' => lambda {
    puts "Rock Paper Scissors"

#scores
compScore = 0
humanScore = 0

until compScore == 5 || humanScore == 5

    puts "Select your weapon. Rock, paper or scissors?"

    human = gets.chomp.downcase
    comp = ["rock", "paper", "scissors"].sample

    #human wins
    if (human == "rock" && comp == "scissors") || (human == "scissors" && comp == "paper") || (human == "paper" && comp == "rock")
        p "You won!"
        humanScore += 1

    #draws
    elsif (human == "rock" && comp == "rock") || (human == "paper" && comp == "paper") || (human == "scissors" && comp == "scissors")
        p "Draw! No point awarded"

    #computer wins
    else compScore += 1
        p "You lose."   
    end

    #Resulted Scores
    p "Human Score: #{humanScore}"
    p "Computer Score: #{compScore}"

    #Resulted Choices
    p "Human chose: #{human}"
    p "Computer chose: #{comp}"
end
    #Tell who wins
    p humanScore > compScore ? ("YOU WIN!") : ("COMPUTER WINS!.")
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
sleep 0.7
puts "GitHub: EnterTheVoid-x86/Ruby-Shell-Unofficial".blink.green
sleep 0.7
puts "Maintained by ^--- that guy".blink.green
sleep 0.7
begin
  while input = Readline.readline("#{Etc.getlogin}@#{Socket.gethostname}:~#{Dir.pwd} #{config['prompt']}", true).strip # NVM, need to fix broken prompt

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
    rescue IOError => h
      # File not given perms, etc.
      puts "Failed to open file."
    ensure
      file.close unless file.nil?
    end
  end
  # screw stackoverflow lol

rescue Interrupt => e
  # Ensuring that the shell still gets executed if interrupted
  puts "^C"
  retry
rescue NoMethodError => d
  printf "\nQuitting...".red
  sleep 1
  puts "\e[H\e[2J"
  sleep 0.2
rescue SystemExit => f 
  printf "\nQuitting...".red
  sleep 1
  puts "\e[H\e[2J"
  sleep 0.2
rescue StandardError => g
  puts "rsh: invalid quote"
  retry
end