# frozen_string_literal: true

require_relative 'sliding_piece'

class Queen < SlidingPiece
  OFFSETS = (ORTHOGONAL + DIAGONAL).freeze

  def self.to_unicode_symbol(color)
    color == COLOR.first ? "\u2655" : "\u265B"
  end

  def initialize(position, color = :white, short = 'Q')
    super
  end
end
