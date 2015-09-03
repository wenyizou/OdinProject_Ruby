def caesar_cipher(str,offset)
	
	offset%=26
	res=''
	str.each_char do |c|
		if ('a'..'z').to_a.include? c
			res << (((c.ord-'a'.ord)+offset)%26 + 'a'.ord).chr
		elsif ('A'..'Z').to_a.include? c
			res << (((c.ord-'A'.ord)+offset)%26 + 'A'.ord).chr
		else
			res << c
		end
	end
	return res
end