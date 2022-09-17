require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(array)
    @array = array.uniq.sort
    @root = nil
  end

  def build_tree(array = @array)
    return nil if array.empty?

    mid = array.size / 2
    root = Node.new(array[mid])
    root.left_node = build_tree(array[...mid])
    root.right_node = build_tree(array[mid + 1..])

    @root = root
  end

  def pretty_print(root = @root, prefix = '', is_left = true)
    return if root.nil?

    pretty_print(root.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if root.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{root.data}"
    pretty_print(root.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if root.left_node
  end

  def insert(root = @root, value)
    return @root = Node.new(value) if root.nil?
    return root if root.data == value

    if root.data < value
      root.right_node = insert(root.right_node, value)
    else
      root.left_node = insert(root.left_node, value)
    end

    @root = root
  end

  def delete(root = @root, data)
    return root if root.nil?

    if data < root.data
      root.left_node = delete(root.left_node, data)
    elsif data > root.data
      root.right_node = delete(root.right_node, data)
    else
      if root.left_node.nil?
        return root.right_node
      elsif root.right_node.nil?
        return root.left_node
      end

      root.data = min_data_node(root.right_node).data
      root.right_node = delete(root.right_node, root.data)
    end

    root
  end

  def find(root = @root, data)
    return 'No such node' if root.nil?
    return root if root.data == data
    return find(root.left_node, data) if data < root.data

    find(root.right_node, data)
  end

  def level_order_iter(root = @root, &block)
    return nil if root.nil?

    queue, result = [root], []

    until queue.empty?
      current = queue.first
      queue << current.left_node unless current.left_node.nil?
      queue << current.right_node unless current.right_node.nil?

      unless block.nil?
        block.call(queue.shift)
        next
      end

      result << queue.shift.data
    end

    result if block.nil?
  end

  def level_order_rec(root = @root, result = [], queue = [], &block)
    return nil if root.nil?

    queue << root.left_node unless root.left_node.nil?
    queue << root.right_node unless root.right_node.nil?
    block.nil? ? result.push(root.data) : block.call(root)

    return result if queue.empty? && block.nil?

    level_order_rec(queue.shift, result, queue, &block)
  end

  def preorder(root = @root, result = [], &block)
    return nil if root.nil?

    block.nil? ? result.push(root.data) : block.call(root)
    preorder(root.left_node, result, &block)
    preorder(root.right_node, result, &block)

    result if block.nil?
  end

  def inorder(root = @root, result = [], &block)
    return nil if root.nil?

    inorder(root.left_node, result, &block)
    block.nil? ? result.push(root.data) : block.call(root)
    inorder(root.right_node, result, &block)

    result if block.nil?
  end

  def postorder(root = @root, result = [], &block)
    return nil if root.nil?

    postorder(root.left_node, result, &block)
    postorder(root.right_node, result, &block)
    block.nil? ? result.push(root.data) : block.call(root)

    result if block.nil?
  end

  def height(root = @root, height = -1)
    return height if root.nil?

    [height(root.left_node), height(root.right_node)].max + 1
  end

  def depth(root = @root, result = 0, data)
    return nil if root.nil?
    return result if data == root.data
    return depth(root.left_node, result + 1, data) if data < root.data

    depth(root.right_node, result + 1, data)
  end

  def balanced?(root = @root)
    return true if root.nil?

    left_height = height(root.left_node)
    right_height = height(root.right_node)

    return true if (left_height - right_height).abs <= 1 && balanced?(root.left_node) && balanced?(root.right_node)

    false
  end

  def rebalance!
    @root = build_tree(inorder)
  end

  private

  def min_data_node(node)
    current = node

    until current.left_node.nil?
      current = current.left_node
    end

    current
  end
end

bst = Tree.new(Array.new(15) { rand(1..100) })
root = bst.build_tree
puts bst.balanced?
p bst.level_order_rec
p bst.preorder
p bst.postorder
p bst.inorder
bst.insert(101)
bst.insert(102)
bst.insert(103)
puts bst.balanced?
bst.rebalance!
puts bst.balanced?
p bst.level_order_rec
p bst.preorder
p bst.postorder
p bst.inorder
