# frozen_string_literal: true

require_relative 'node'

class LinkedList
  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    return prepend(value) if @head.nil?

    current_node = @head
    current_node = current_node.next_node until current_node == @tail

    node = Node.new(value, nil)
    @tail = current_node.next_node = node
  end

  def prepend(value)
    node = Node.new(value, @head)

    @tail = node if @head.nil?
    @head = node
  end

  def size
    return 0 if @head.nil?

    counter = 1
    current_node = @head
    until current_node == @tail
      current_node = current_node.next_node
      counter += 1
    end

    counter
  end

  attr_reader :head, :tail

  def at(index)
    return 'List empty' if @head.nil?
    return 'Index out of range' unless index < size && index >= 0

    counter = 0
    current_node = @head
    until counter == index
      begin
        current_node = current_node.next_node
      rescue StandardError
        puts "Index #{index} out of range"
        exit
      end

      counter += 1
    end

    current_node
  end

  def pop
    return 'List empty' if @head.nil?

    current_node = @head
    current_node = current_node.next_node until current_node.next_node == @tail

    current_node.next_node = nil
    @tail = current_node
  end

  def contains?(value)
    return false if @head.nil?

    current_node = @head
    until current_node.nil?
      return true if current_node.value == value

      current_node = current_node.next_node
    end

    false
  end

  def find(value)
    return if @head.nil?

    counter = 0
    current_node = @head
    until current_node.nil?
      return counter if current_node.value == value

      current_node = current_node.next_node
      counter += 1
    end

    nil
  end

  def to_s
    result = ''
    node = @head

    until node.nil?
      result << "(#{node}) -> "
      node = node.next_node
    end
    result << 'nil'
  end

  def insert_at(value, index)
    return 'Index out of range' if index > size || index.negative?
    return prepend(value) if index.zero?

    node = Node.new(value, at(index))
    at(index - 1).next_node = node
    @tail = node if node.next_node.nil?
  end

  def remove_at(index)
    return 'Index out of range' if index >= size || index.negative?
    return @head = at(1) if index.zero?

    if at(index) == @tail
      @tail = at(index - 1)
      @tail.next_node = nil
    else
      at(index - 1).next_node = at(index).next_node.nil? ? nil : at(index).next_node
    end
  end
end

linked_list = LinkedList.new
linked_list.prepend('B')
linked_list.prepend('A')
linked_list.append('C')
puts linked_list
puts "List size #{linked_list.size}"
puts "First node: (#{linked_list.head})"
puts "Last node (#{linked_list.tail})"
puts "Node at index: #{linked_list.at(1)}"
linked_list.pop
puts "Pop last item: #{linked_list}"
puts linked_list.contains?('C')
puts linked_list.find('B')
linked_list.insert_at('D', 1)
puts linked_list
linked_list.remove_at(1)
puts linked_list
