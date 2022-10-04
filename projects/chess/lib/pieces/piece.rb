# frozen_string_literal: true

class Piece
  COLOR = %i[white black].freeze
  ORTHOGONAL = [[0, 1], [0, -1], [1, 0], [-1, 0]].freeze
  DIAGONAL = [[-1, -1], [1, -1], [-1, 1], [1, 1]].freeze

  attr_reader :short, :color
  attr_accessor :position

  def self.to_unicode_symbol(color); end

  def initialize(position, color, short)
    @position = position
    @short = short
    @color = color
    @unicode_symbol = self.class.to_unicode_symbol(color)
  end

  def to_s
    @unicode_symbol
  end

  def valid_moves(board)
    next_moves(board).reject { |move| move_into_check?(board, move) }
  end

  def next_moves(board); end

  def move_into_check?(board, move)
    temp_board = Marshal.load(Marshal.dump(board))
    temp_board.move_piece!(position, move)
    temp_board.check?(color)
  end
end
