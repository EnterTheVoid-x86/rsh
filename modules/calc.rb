#!/usr/bin/ruby

def calc
  puts "Enter 'q' to quit."

  while true
    print ">> "
    str = gets.chomp.split(" ")  # splits into array, rejects blanks
    return if str[0] == 'exit'     # quit if first element is 'q', 'exit', or 'quit'
    return if str[0] == 'quit'
    return if str[0] == 'q'
    

    operand1 = str[0].to_i
    operand2 = str[2].to_i
    operator = str[1].to_sym

    case operator
    when :+ then puts operand1 + operand2
    when :- then puts operand1 - operand2
    when :* then puts operand1 * operand2
    when :/ then puts operand1 / operand2
    when :% then puts operand1 % operand2
    when :^ then puts operand1 ** operand2
    when :"=" then puts operand1 == operand2
    when :> then puts operand1 > operand2
    when :< then puts operand1 < operand2
    when :x then puts operand1 * operand2
    when :"<>" then puts operand1 != operand2
    else
      puts "Invalid input"
    end
  end

rescue NoMethodError
  puts "Invaid input"
retry

rescue Interrupt
  puts "Enter 'q' to quit."
retry

rescue ZeroDivisionError
  puts "Cannot divide by zero."
  retry
  
end

if __FILE__ == $0
  calc
end