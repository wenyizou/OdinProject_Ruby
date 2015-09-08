require_relative './node'

class BST

    attr_accessor :root

  def initialize(ary=nil)
    @root = nil
    return @root if ary.nil?
    @root = build_Tree(ary)
  end

 # build the tree
  def build_Tree(ary)
    return nil if ary.empty?
    root = Node.new(ary[0])
    ary[1..-1].each do |x|
      n=root
      while true
        if n.value>x
          if n.left_child!=nil
            n=n.left_child
          else
            n.left_child = Node.new(x)
            break
          end
        else
          if n.right_child!=nil
            n=n.right_child
          else
            n.right_child = Node.new(x)
            break
          end
        end
      end
    end
    return root
  end


  def binary_Search(value)
    n=@root
    until(n.nil?)
      return n if n.value = value
      n=n.left_child if n.value>value
      n=n.right_child if n.value<value
    end
    return nil
  end

  def bfs(value)
    queue = []
    queue.push(@root)
    until queue.empty?
      n=queue.shift()
      next if n.nil?
      return n if n.value = value
      queue.push(n.left_child)
      queue.push(n.right_child)
    end
    return nil
  end

    def dfs(value)
      stack = []
      stack.push(@root)
      until stack.empty?
        n=stack.pop()
        next if n.nil?
        return n if n.value = value
        stack.push(n.left_child)
        stack.push(n.right_child)
      end
      return nil
    end

end

tree=BST.new([3,1,2,4,5])
r1=tree.binary_Search(4)
r2=tree.bfs(4)
r3=tree.dfs(4)
puts 'test'