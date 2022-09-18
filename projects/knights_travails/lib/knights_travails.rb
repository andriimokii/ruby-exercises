require_relative 'knight'

class KnightsTravails
  SIDE_LENGTH = 8

  def initialize
    @board = (0..SIDE_LENGTH - 1).to_a.repeated_permutation(2).to_a
  end

  def knight_moves(start_pos, end_pos)
    end_node = create_bst(start_pos, end_pos)
    path = search_path(end_node, start_pos)
    display_path(path)
  end

  private

  def create_bst(start_pos, end_pos)
    queue, current = [], Knight.new(start_pos)

    until current.position == end_pos
      current.next_moves.each do |move|
        current.children << knight = Knight.new(move, current)
        queue << knight
      end
      current = queue.shift
    end

    current
  end

  def search_path(end_node, start_pos, path = [])
    return nil if end_node.nil?

    path << end_node.position
    return path.reverse if end_node.position == start_pos
    search_path(end_node.parent, start_pos, path)
  end

  def display_path(path)
    puts "You made it in #{path.size - 1}! Here's your path:"
    path.each { |move| p move }
  end
end

kt = KnightsTravails.new
kt.knight_moves([3, 3], [4, 3])