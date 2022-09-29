# frozen_string_literal: true

require_relative 'sliding_piece'

class Rook < SlidingPiece
  OFFSETS = ORTHOGONAL.freeze

  attr_reader :has_moved

  def initialize(position, color = :white, short = 'R')
    super
    @has_moved = false
  end

  def position=(position)
    @position = position
    @has_moved = true
  end

  def to_unicode_symbol(color)
    color == :white ? "\u2656" : "\u265C"
  end
end
