# frozen_string_literal: true

require_relative 'sliding_piece'

class Bishop < SlidingPiece
  OFFSETS = DIAGONAL.freeze

  def self.to_unicode_symbol(color)
    color == COLOR.first ? "\u2657" : "\u265D"
  end

  def initialize(position, color = :white, short = 'B')
    super
  end
end
