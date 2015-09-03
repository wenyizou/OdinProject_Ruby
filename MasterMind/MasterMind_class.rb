
class MasterMind
  attr_reader :code
  attr_reader :guess_now
  attr_reader :guess_history
  attr_reader :guess_result_history
  @@color=['r','g','b','y','o','w','p']
  def initialize
    # init with 4 random color
    @guess_history=Array.new(10,['-','-','-','-'])
    @guess_result_history = Array.new(10,['.','.'])
    @guess_now=['-','-','-','-']
    @code=[]
    4.times do
      code.push(@@color[rand(0..6)])
    end
  end

  #=== display function, for display the board on console
  def display
    puts " "*35 + "===MasterMind!===  right: guess  position"
    for col in 0..9
      print " "*40
      for row in 0..3
        print guess_history[col][row] + ' '
      end
      puts " "*15 + guess_result_history[col][0] + "       " + guess_result_history[col][1]
      puts "\n"
    end
    puts " "*20 + "input 4 color initials for making your choice, 'h' for help, 'q' for quit this round"
  end

  def check(color_str,guess_times)
    good_pos,good_guess = 0,0
    for i in 0..3     # check if 4 initials inside color set
      if !@@color.include? color_str[i]
        puts " "*20 + "please input 4 valid color initials"
        return 0
      end
    end
    @guess_now = color_str.split('')
    @guess_history[guess_times-1] = @guess_now.clone

    # position check
    for j in 0..3
      good_pos +=1 if @guess_now[j] == @code[j]
    end
    for j in 0..3
      if pos=(@guess_now.index(@code[j]))
        @guess_now.delete_at(pos)
        good_guess+=1
      end
    end

    # win or not check
    @guess_result_history[guess_times-1] = [good_guess.to_s, good_pos.to_s]
    if good_pos==4
      puts " "*20 + "You Get The Right Code!" + color_str + "\n"
      return 2
    else
      display
      return 1
    end
    return 0
  end

  def help
    puts "this is help"
  end

  def show_code
    return @code.join('')
  end

end
