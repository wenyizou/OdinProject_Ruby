# testing for substings

require_relative './substrings'

describe 'substings' do
		dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
	it 'after calling' do
		substrings("below", dictionary).should == {"below"=>1, "low"=>1}
		substrings("Howdy partner, sit down! How's it going?", dictionary) == \
		{"down"=>1,"go"=>1, "going"=>1, "how"=>2, "howdy"=>1, "it"=>2, "i"=> 3, "own"=>1,"part"=>1,"partner"=>1,"sit"=>1}
	end
end