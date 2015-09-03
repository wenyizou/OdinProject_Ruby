def stock_picker(info)
  return [0,0] if info.nil? || info.length<2
  buy,sell = 0, 1
  max=[buy,sell]
  for sell in buy+1...info.length
    if info[sell]<info[buy]
      buy=sell
    elsif info[sell]-info[buy]>info[max[1]]-info[max[0]]
      max[0]=buy
      max[1]=sell
    end
    sell+=1
  end
  return [0,0] if info[max[1]]-info[max[0]]<0
  return max
end