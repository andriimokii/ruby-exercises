# frozen_string_literal: true

require_relative 'stepping_piece'

class Knight < SteppingPiece
  OFFSETS = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]].freeze

  def initialize(position, color = :white, short = 'N')
    super
  end

  def to_unicode_symbol(color)
    color == :white ? "\u2658" : "\u265E"
  end
end
