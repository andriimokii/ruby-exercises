# frozen_string_literal: true

require_relative 'stepping_piece'

class King < SteppingPiece
  OFFSETS = (ORTHOGONAL + DIAGONAL).freeze

  def initialize(position, color = :white, short = 'K')
    super
    @has_moved = false
  end

  def position=(position)
    @position = position
    @has_moved = true
  end

  def to_unicode_symbol(color)
    color == :white ? "\u2654" : "\u265A"
  end
end
