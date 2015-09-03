puts 'asd'

module Enumerable
  def my_each
    return self unless block_given?
    for i in self
      yield(i)
    end
  end
end

[1,2].each.class
[1,2].my_each.class
