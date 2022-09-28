# frozen_string_literal: true

require_relative 'sliding_piece'

class Queen < SlidingPiece
  OFFSETS = (ORTHOGONAL + DIAGONAL).freeze

  def initialize(position, color = :white, short = 'Q')
    super
  end

  def to_unicode_symbol(color)
    color == :white ? "\u2655" : "\u265B"
  end
end
