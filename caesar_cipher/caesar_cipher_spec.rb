# testing for caesar_cipher

require_relative './caesar_cipher'

describe 'caesar_cipher function'  do
	it 'after calling' do
		caesar_cipher("Abc Def",3).should == "Def Ghi"
		caesar_cipher("What a string!", 5).should == "Bmfy f xywnsl!"
	end
end