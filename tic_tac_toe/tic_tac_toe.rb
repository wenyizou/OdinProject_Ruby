#====== below are class for tic tac toe

class TicTacToe 

	attr_reader :board

	def initialize
		# init with 9 dot , display in 3x3
		@board = Array.new(9,'.')
	end

	#=== display function, for display the board on console
	def display
		puts " "*35 + "===Tic-Tac-Toe!===\n"
		for col in 0..2
			print " "*40
			for row in 0..2
				print board[col*3+row] + '  '
			end
			puts "\n"
		end
		puts " "*20 + "press 0-9 for making your choice, 'h' for help, 'q' for quit this round"
	end

	#=== update function, for updating the player choice to board
	def update(pos,player)
		if !(1..9).include? pos
			puts " "*20 + "please input a vaild number or command char"
			return false
		else
			chr = 'O' if player%2==1
			chr = 'X' if player%2==0
			if @board[pos-1] == '.'
				@board[pos-1] = chr
			else
				puts " "*20 + "the position has already been filled, please choose a vaild one"
				return false
			end
		end
		
		return true
	end

	#=== help function, for display the help manual for user
	def help
		puts " "*35 + "Rules of tic_tac_toe"
		puts " "*20 + "2 players take turns choose position to fill the 3x3 board"
		puts " "*20 + "Use 1-9 number to choose the position you want to fill"
		puts " "*20 + "Win if any 3-block-line(including diag) get a 3x Combo"
		puts " "*42 + "Enjoy!"
	end

	#=== check win function, decide win, lost or tie
	def check
		che=[]
		for i in (0..8).step(3)    # detect row
			che.push(@board[i]+@board[i+1]+@board[i+2])
		end  
		for i in (0..2)        # detect column
			che.push(@board[i]+@board[i+3]+@board[i+6])
		end
			# detect diag
		che.push(@board[0]+@board[4]+@board[8])
		che.push(@board[2]+@board[4]+@board[6])

		if che.include? 'OOO'
			display
			puts " "*40 + "Player 1 Win!\n"
			return true
		elsif che.include? 'XXX'
			display
			puts " "*40 + "Player 2 Win!\n"
			return true
		elsif !@board.include? '.'
			display
			puts " "*40 + "Draw Game!\n"
			return true
		else
			return false
		end
	end

end

#====== game start entry =======
	puts " "*35 + "=====Welcome!====="
	puts " "*35 + "===Tic-Tac-Toe!==="
	tictactoe = TicTacToe.new
loop do
	puts " "*20 + "press 's' for start a new game, 'h' for help, 'q' for quit"
	chr = gets.chomp
	if chr=='s' || chr=='S'
		tictactoe = TicTacToe.new
		tictactoe.display
		player = 1
		# in game entry
		loop do
			chr = gets.chomp
			if ('1'..'9').include? chr
				player += 1 if tictactoe.update(chr.to_i , player)   # update the choice
				break if tictactoe.check     # check win or not
				tictactoe.display
			elsif chr == 'h'
				tictactoe.help
			elsif chr == 'q' || chr == 'Q'
				break
			else
				puts " "*20 + "please input a vaild number or command char"
			end
		end
	elsif chr=='q' || chr == 'Q'
		break 
	elsif chr=='h'
		tictactoe.help
	else
		puts " "*20 + "please input a vaild command char"
	end

end



