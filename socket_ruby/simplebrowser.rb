# modified by wenyi, based on Donaldali 
require 'socket'
require 'json'

# Control the running of the elementary browser
def run_Browser()
	while true
		display_Main_Menu()
		choice = prompt_And_Get('','Please enter a vaild number',/^[1234]$/)
		case choice.to_i
		when 1,2,3 
			socket = make_Socket_Connection()
			if socket == 0
				puts "Fail to build connection, please try again"
				next
			else
				after_Connection(socket)
			end
		when 4 then break
		end
	end
	puts "Closing browser...bye"
end

# Control the running of the elementary browser
def after_Connection(socket)
	while true
		display_Method_Menu()
		choice = prompt_And_Get('','Please enter a vaild number',/^[123]$/)
		case choice.to_i
		when 1 then make_GET_Request(socket)
		when 2 then make_POST_Request(socket)
		when 3 
			puts "Disconnected"
			socket.close
			break
		end
	end
end

# Main Menu to run browser
def display_Main_Menu()
	puts "Browser Menu"
	puts "============"
	puts "1. Make a connection"
	puts "2. Make a connection(WTF? Same as above?)"
	puts "3. Make a connection(Make connection first!)"
	puts "4. Exit"
end

# Menu to run browser
def display_Method_Menu()
	puts "Method Menu"
	puts "============"
	puts "1. Make a GET request"
	puts "2. Make a POST request"
	puts "3. Exit"
end

def make_Socket_Connection()
	host = prompt_And_Get('Please enter the host name or ip address','The host name/ip is invalid, please try again',/^\/?\w/)
	port = '99999'
	until (1..65536).include? port.to_i
		port = prompt_And_Get('Please enter the port number between 1 to 65536','The port number is invalid, please try again',/^\d/)
	end
	begin
	socket = TCPSocket.open(host,port)
	puts "Connection build successfully!"
	return socket

	rescue Exception => exception
		case exception
		when Errno::ECONNRESET,Errno::ECONNABORTED,Errno::ETIMEDOUT
	        puts "Socket: #{exception.class}"
	        return 0
        else
	        raise exception
	    end
	end
end

# prompt user to input a command or string which the program need
# if the leave pattern blank when call, it return if input is not blank
# if give the pattern, it will return only the input match the pattern
def prompt_And_Get(prompt_message,input_error_message,pattern=nil)
	while true
		puts prompt_message
		user_input = gets.chomp
		if pattern.nil?
			unless user_input==''
				return user_input 
			else
				puts input_error_message
			end
		else
			if user_input =~ pattern
				return user_input
			else
				puts input_error_message
			end
		end
	end
end

def make_GET_Request(socket)
	# /^\/?\w/ is the regexp for file name, can't start with non-alphabic charactor, can start with '/'
	target = prompt_And_Get('Please enter the file(path) to GET','The file name is in valid, please try again',/^\/?\w/)  
	target = "/#{target}" unless target[0] == '/'
	initial = generic_Generate_Initial('GET',target)
	request = generic_Generate_Request(initial,'','')
	generic_Make_Request(socket,request)
end

def make_POST_Request(socket)
	body = get_viking_data.to_json
	initial = generic_Generate_Initial('POST','/viking')
	headers = generic_Generate_Headers(body)
	request = generic_Generate_Request(initial,headers,body)
	generic_Make_Request(socket,request)
end

def generic_Generate_Initial(method,target)
	initial = ''
	initial << "#{method} " << "#{target} HTTP/1.1"
	return initial
end

def generic_Generate_Headers(body)
	headers = ''
	headers << "Host: #{Socket.ip_address_list.select{|x| x.ipv4_private?}[0].ip_address}\r\n"
	headers << "Date: #{Time.now.ctime}\r\n"
	if body.length>0
		headers << "Content-Type => application/x-www-form-urlencoded\r\n"
		headers << "Content-Length => #{body.size}\r\n"
	end
	return headers
end

def generic_Generate_Request(initial,headers,body)
	s=initial
	s << "\r\n" << headers      # headers start in second line
	if body.length>0
		s << "\r\n" << body     # body start after a blank line, first \r\n is for change line from headers, second is for blank line
	end
	return s
end

def generic_Make_Request(socket,request)
	puts "sending request"
	socket.send(request,0)
	puts 'waiting for response'
	response = socket.recv(1000)
	puts 'response received'
	puts response
end

# Get information from user for a viking and make viking hash
def get_viking_data
	puts "Register a viking for a raid..."
	name = (prompt_And_Get('Please enter viking\'s name: ','The username is in valid, please try again',/^\w/)).strip
	email = (prompt_And_Get('Please enter viking\'s email: ','The email is in valid, please try again',/^\w/)).strip
	{ viking: { name: name, email: email } }
end

# main browser entry
run_Browser()