#!/usr/bin/env ruby

# rsh v1.40
# Written by EnterTheVoidx86
require 'readline'
require 'shellwords'
require 'socket'
require 'etc'
require 'yaml'
require 'io/console'


time = Time.new




require_relative 'modules/colors.rb'

config = YAML.load_file('config.yml')
workingdir = Dir.pwd

logo = YAML.load_file('logo.yml')

# Defines the system function to call system commands


def system(command)
  pid = fork {
    exec(command)
  }
  Process.wait pid
end



def print_exception(exception, explicit)
  puts "rsh: error occurred; details below"
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
    system "clear"
  },
  'beep' => lambda {
    puts 7.chr, "Beep!"
  },
  'inf' => lambda {
    puts "rsh v1.40".blink.red
    printf "Powered by Ruby v3.03".blink.red
    puts "\nMaintained by", "EnterTheVoid-x86".blink.green
    printf "\nCreated 2020, current version was released on Janurary 10, 2022.\n".blink.magenta
  },
  'info' => lambda {
    puts "rsh v1.40".blink.red
    printf "Powered by Ruby v3.03".blink.red
    puts "\nMaintained by", "EnterTheVoid-x86".blink.green
    printf "\nCreated 2020, current version was released on Janurary 10, 2022.\n".blink.magenta
  },
  'ver' => lambda {
    puts "rsh v1.40".blink.red
  },
  'restart' => lambda {
    system ("clear")
    load "rsh"
  },
  'print 1 / 0' => lambda {
    puts "rsh: error: division by zero is undefined".blink.red
  },
  'version' => lambda {
    puts "rsh v1.40".blink.red
  },
  'disable_logo' => lambda {
    puts "Logo is now disabled."
    system "echo 'logo_enabled: false' > logo.yml"
  },
  'enable_logo' => lambda {
    puts "Logo is now enabled."
    system "echo 'logo_enabled: true' > logo.yml"
  },
  'time' => lambda {
    puts "The time is:", time.strftime("%I:%M:%S %p.") 
  },
  'date' => lambda {
    puts "Today is:", time.strftime("%m/%d/%Y.") 
  },
  'dirname' => lambda {
    puts Dir.pwd
  },
  'uninstall' => lambda {
    puts "Are you sure you want to uninstall rsh? (y/n)".blink.red
    yesorno = gets.chomp
    if yesorno == "y"
      system ("clear")
      puts 7.chr
      sleep 4
      puts "rsh is now uninstalling.".blink.red
      sleep 1
      system ("clear")
      puts "rsh is now uninstalling..".blink.red
      sleep 1
      system ("clear")
      puts "rsh is now uninstalling...".blink.red
      sleep 1
      system ("clear")
      puts "rsh is now uninstalling.".blink.red
      sleep 1
      system ("clear")
      puts "rsh is now uninstalling..".blink.red
      sleep 1
      system ("clear")
      puts "rsh is now uninstalling...".blink.red
      puts "Uninstall complete. We're sad to see you go!".red
      system ("rm -rf rsh")
      system ("rm -rf rshdev")
      system ("rm -rf main")
      system ("rm -rf omr")
      system ("rm -rf logo.yml")
      system ("rm -rf config.yml")
      system ("rm -rf README.md")
      system ("rm -rf history.txt")
      system ("rm -rf modules/")
      system ("rm -rf Gemfile")
      system ("rm -rf Gemfile.lock")
      system ("rm -rf logo.txt")
      exit
      end
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
    printf "\ninf, info: Prints info about the shell"
    printf "\ntime, 24hr: Prints the current time"
    printf "\ndate, europedate: Prints the current date"
    printf "\ncls, clear: Clears the screen"
    printf "\nunixtime: Prints the current time in unix timestamps"
    printf "\ncalc, calculator: self-explanitory."
    printf "\nbeep: It beeps.\n"
    printf "rps, rockpaperscissors: Play a game of rock paper scissors\n"
    printf "ver, version: Prints shell version\n"
    printf "disable_logo: Disables ASCII logo on startup.\n"
    printf "enable_logo: Enables ASCII logo on startup.\n"
    printf "fetch: displays user system info in a small panel. based on pfetch by dylanaraps.\n"
    printf "All regular bash commands are also in the shell, such as cd and exit.\n"
  },
  'clock' => lambda {
    load "modules/clock.rb"
  },
  'fetch' => lambda {
    system ("./modules/fetch.x")
  },
  ';' => lambda {
    puts "rsh: syntax error near unexpected token ':'"
  },
  '|' => lambda {
    puts "rsh: syntax error near unexpected token '|'"
  },
  'calc' => lambda {
    load "ruby modules/calc.rb"
  },
  'calculator' => lambda {
    load "ruby modules/calc.rb"
  },
  'racism' => lambda {
    puts "You better freakin' not be racist! I'll kill you if you are!"
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
    puts "EnterTheVoidx86, made the shell".green
    sleep 2
    puts "Stargirl-chan, created the original Ruby Shell".red
    sleep 2
    puts "Ann1kaB, made the ASCII art module".blue
    sleep 2
    puts "Thanks for using RSH.".red
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
        puts "You won!"
        humanScore += 1

    #draws
    elsif (human == "rock" && comp == "rock") || (human == "paper" && comp == "paper") || (human == "scissors" && comp == "scissors")
        puts "Draw! No point awarded"

    #computer wins
    else compScore += 1
        puts "You lose."   
    end

    #Resulted Scores
    puts "Human Score: #{humanScore}"
    puts "Computer Score: #{compScore}"

    #Resulted Choices
    puts "Human chose: #{human}"
    puts "Computer chose: #{comp}"
end
    #Tell who wins
    puts humanScore > compScore ? ("YOU WIN! :D") : ("YOU LOSE! :(")
  }
}
# Loads the color module on class String
# Used to color strings ¯\_(ツ)_/¯

class String
  include Colors
end

# First boot message

if config['first_boot'] == true
  puts "Welcome to rsh! We see that it is your first time running the shell. You can use the command 'enable_logo' to enable an ASCII art startup logo, or 'disable_logo' to disable the ASCII art logo. Enter 'help' for some basic commands you can use. And with that out of the way, thanks for downloading rsh! :D".red
  sleep 4
  puts "Press any key to continue..."
  STDIN.getch
  system ("clear")
  sleep 4
  puts "rsh is getting ready for the first time."
  sleep 1
  system ("clear")
  puts "rsh is getting ready for the first time.."
  sleep 1
  system ("clear")
  puts "rsh is getting ready for the first time..."
  sleep 1
  system ("clear")
  puts "rsh is getting ready for the first time."
  sleep 1
  system ("clear")
  puts "rsh is getting ready for the first time.."
  sleep 1
  system ("clear")
  puts "rsh is getting ready for the first time..."
  sleep 1
  system ("clear")
  sleep 2
  system "sh modules/first_boot.sh"
end

# ascii art from ann1kab, thanks by the way!
def render_ascii_art(string)
  File.readlines(string) do |line|
    puts line
  end
end

# Put the warning inside README.md
if logo['logo_enabled'] == true
  puts render_ascii_art(config['ascii'])
  sleep 1
end

system ("export SHELL=rsh")
puts config['message'].blink.red
sleep 0.7
puts "GitHub: EnterTheVoid-x86/rsh".blink.green
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
      puts "rsh: failed to open critical file."
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
  system ("clear")
  sleep 0.2
rescue SystemExit => f 
  printf "\nQuitting...".red
  sleep 1
  system ("clear")
  sleep 0.2
rescue StandardError => g
  puts "rsh: error constructing the regular expression from the pattern '^/bin/. $' failed. caused by: Literal '\n\ not allowed."
  retry
end
