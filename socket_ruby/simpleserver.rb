# modified by wenyi, based on Donaldali 
require 'socket'
require 'json'

def handle_Request(request)
	initial,headers,body = parse_Request(request)  # split to 3 part
	method = get_Method(initial)
	case method
	when 'GET' then handle_GET(initial)  # only use initial
	when 'POST' then handle_POST(request)
	else handle_Notsupported
	end
end

# parse the request send from client to 3 part
def parse_Request(request)
	initial_and_headers,body = initialandheaders_Body_Split(request)
	initial,headers = initial_Headers_Split(initial_and_headers)
	return initial,headers,body

end

#split the initial with headers with body part
def initialandheaders_Body_Split(request)
	if request.include?("\r\n\r\n")  # if body exist, a blank line must exist
		initial_and_headers,body = request.split("\r\n\r\n",2)
	else
		initial_and_headers,body = request,''
	end
end

# split the initial and headers part
def initial_Headers_Split(initial_and_headers)
	if initial_and_headers.include?("\r\n")  # if body exist, a blank line must exist
		initial,headers = initial_and_headers.split("\r\n",2)
	else
		initial,headers = initial_and_headers,''
	end
end

# return the http request method
def get_Method(initial)
	initial.split(' ',3)[0]
end

# return the path of http request: GET 
def get_Path(initial)
	initial.split(' ',3)[1]
end

# handle and return response for GET request
def handle_GET(initial)
	request_path = get_Path(initial)
	request_path = request_path[1..-1] if request_path[0] == '/'
	if File.exist?(request_path)
		create_Found_Response(request_path)
	else
		create_Not_Found_Response(request_path)
	end
end

# return 200 Found for GET request
def create_Found_Response(request_path)
	body = File.read(request_path)
	initial = generic_Generate_Initial(200)
	headers = generic_Generate_Headers(body)
	generic_Generate_Response(initial,headers,body)
end

# return 404 Not Found for GET request
def create_Not_Found_Response(request_path)
	body = ''
	initial = generic_Generate_Initial(404)
	headers = generic_Generate_Headers(body)
	generic_Generate_Response(initial,headers,body)
end

# return response for POST request
def handle_POST(request)
	initial_and_headers,body = initialandheaders_Body_Split(request)
	initial,headers = initial_Headers_Split(initial_and_headers)
	params = JSON.parse(body)   # parse parameters from json file
	contents = File.read "thanks.html"
	contents = modify_content(contents, params["viking"])
	initial = generic_Generate_Initial(200)
	headers = generic_Generate_Headers(contents)
	generic_Generate_Response(initial,headers,contents)
end

# handle other situation
def handle_Notsupported
	'Method not supported'
end

def modify_content(contents, viking_data)
	target = "<%= yield %>"
	target_line = contents.split("\n").find { |line| line.include?(target) }
	insert_string = ""
	viking_data.each do |key, value| 
		insert_string += target_line.sub(target, "<li>#{ key }: #{ value }</li>\n")
	end
	contents.sub(target_line, insert_string.chomp)
end

# generic generate initial of the respone
def generic_Generate_Initial(httpcode)
	initial=''
	case httpcode
	when 200 then initial = 'HTTP/1.1 200 OK'
	when 404 then initial = 'HTTP/1.1 404 Not Found'  # this server only support these 2 code
	end
	return initial
end

# generic generate headers of the respone
def generic_Generate_Headers(body)
	headers = ''
	headers << "Server: #{Socket.ip_address_list.select{|x| x.ipv4_private?}[0].ip_address}\r\n"
	headers << "Date: #{Time.now.ctime}\r\n"
	if body.length>0
		headers << "Content-Type => text/html\r\n"
		headers << "Content-Length => #{body.size}\r\n"
	end
	return headers
end

# generic generate the respone of request
def generic_Generate_Response(initial,headers,body)
	s=initial
	s << "\r\n" << headers      # headers start in second line
	if body.length>0
		s << "\r\n" << body     # body start after a blank line, first \r\n is for change line from headers, second is for blank line
	end
	return s
end



host = '10.0.0.12'
server = TCPServer.open(host,4001)
ip=Socket.ip_address_list.select{|x| x.ipv4_private?}[0].ip_address
loop do
	Thread.start(server.accept) do |client|
	loop do
		begin
		puts 'receiving request'
		request = client.recv(1000)      # receive request from client
		puts 'request received'
		puts "#{request}"
		response = handle_Request(request)
		client.send(response,0)
		puts 'response sent'
		puts 'bye'
		rescue Exception => exception
			case exception
			when Errno::ECONNRESET,Errno::ECONNABORTED,Errno::ETIMEDOUT
		        puts "Connection Lost!"
		        client.close
		        break
	        else
		        raise exception
		    end
		end
	end
end
# client = server.accept
# loop do
# 	begin
# 		puts 'receiving request'
# 		request = client.recv(1000)      # receive request from client
# 		puts 'request received'
# 		puts "#{request}"
# 		response = handle_Request(request)
# 		client.send(response,0)
# 		puts 'response sent'
# 		puts 'bye'
# 	rescue Exception => exception
# 		case exception
# 		when Errno::ECONNRESET,Errno::ECONNABORTED,Errno::ETIMEDOUT
# 	        puts "Connection Lost!"
# 	        client.close
# 	        break
#         else
# 	        raise exception
# 	    end
# 	end
end