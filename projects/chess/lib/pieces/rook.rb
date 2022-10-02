# frozen_string_literal: true

require_relative 'sliding_piece'

class Rook < SlidingPiece
  OFFSETS = ORTHOGONAL.freeze

  attr_reader :has_moved

  def self.to_unicode_symbol(color)
    color == COLOR.first ? "\u2656" : "\u265C"
  end

  def initialize(position, color = :white, short = 'R')
    super
    @has_moved = false
  end

  def position=(position)
    @position = position
    @has_moved = true
  end
end
