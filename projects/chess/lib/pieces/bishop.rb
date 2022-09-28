# frozen_string_literal: true

require_relative 'sliding_piece'

class Bishop < SlidingPiece
  OFFSETS = DIAGONAL.freeze

  def initialize(position, color = :white, short = 'B')
    super
  end

  def to_unicode_symbol(color)
    color == :white ? "\u2657" : "\u265D"
  end
end
