
require_relative './MasterMind_class'
#====== game start entry =======
puts " "*35 + "=====Welcome!====="
puts " "*35 + "===MasterMind!==="
mastermind = MasterMind.new
loop do
  puts " "*20 + "press 's' for start a new game, 'h' for help, 'q' for quit"
  chr = gets.chomp
  if chr=='s' || chr=='S'
    mastermind = MasterMind.new
    mastermind.display
    guess_times = 1
    loop do
      color = gets.chomp
      if color == 'q' || color == 'q'
        break
      elsif color == 'h' || color =='Q'
        mastermind.help
      end
      if color.length != 4   # check if it's 4 chars
        puts " "*20 + "please input 4 valid color initials"
        next
      else
       stat=mastermind.check(color,guess_times)
        next if stat==0
        guess_times+=1 if stat==1
       if guess_times==10
        puts " "*20 + "Sorry! You didn't get the right code:   " + mastermind.show_code + "\n"
        puts " "*20 + "Please Try Again~"
        break
       end
        break if stat==2
      end
    end
    # in game entry
  elsif chr=='q' || chr == 'Q'
    break
  elsif chr=='h'
    mastermind.help
  else
    puts " "*20 + "please input a valid command char"
  end

end