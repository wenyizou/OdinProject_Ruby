# testing for stock_picker

require_relative './stock_picker'

describe 'stock_picker' do
	it 'after calling' do
		#stock_picker([17,3,6,9,15,8,6,1,10]).should == [1,4]
		stock_picker([4,3,2,1,2,3,4,5,2,3]).should == [3,7]
		stock_picker([6,5,4,3,2,1]).should == [0,0]
		stock_picker([7,9,2,3]).should == [0,1]
		stock_picker([7,6]).should == [0,0]
		stock_picker([7]).should == [0,0]
	end
end