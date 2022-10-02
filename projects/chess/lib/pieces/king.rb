# frozen_string_literal: true

require_relative 'stepping_piece'

class King < SteppingPiece
  OFFSETS = (ORTHOGONAL + DIAGONAL).freeze

  attr_reader :has_moved

  def self.to_unicode_symbol(color)
    color == COLOR.first ? "\u2654" : "\u265A"
  end

  def initialize(position, color = :white, short = 'K')
    super
    @has_moved = false
  end

  def position=(position)
    @position = position
    @has_moved = true
  end
end
