def substrings(str,dictionary)
	res={}
	dictionary.each do |w|
		if str.scan(w).length>0
			res[w]||=0
			res[w]+=1
		end
	end
	return res
end