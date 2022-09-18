class Knight
  MOVES = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]].freeze

  attr_reader :position, :parent
  attr_accessor :children

  def initialize(position, parent = nil)
    @parent = parent
    @children = []
    @position = position
  end

  def next_moves
    moves = MOVES.map do |move|
      move.each_with_index.map do |num, index|
        sum = num + position[index]
        sum unless sum < 0 || sum > 7
      end
    end

    moves.reject { |move| move.include?(nil) }
  end
end
