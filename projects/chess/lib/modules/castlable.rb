# frozen_string_literal: true

require_relative 'piece_positionable'

module Castlable
  include PiecePositionable

  BLACK_LONG = [[0, 1], [0, 2], [0, 3]].freeze
  BLACK_SHORT = [[0, 5], [0, 6]].freeze
  WHITE_LONG = [[7, 1], [7, 2], [7, 3]].freeze
  WHITE_SHORT = [[7, 5], [7, 6]].freeze
  SHORT_KING_FILE = 6
  KING_POSITION_OFFSET = [0, 2].freeze

  def castle(pos_from, pos_to)
    move_piece(pos_from, pos_to)
    move_piece(*rook_positions(pos_from, pos_to))
  end

  def castle_verified?(pos_from, pos_to)
    old_rook_position = rook_positions(pos_from, pos_to).first
    color = player_at(pos_from).color

    piece_type_at_position?(pos_from, King) &&
      pos_offset(pos_from, pos_to) == KING_POSITION_OFFSET &&
      !check?(color) &&
      !piece_moved?(pos_from) &&
      !piece_moved?(old_rook_position) &&
      path_empty?(pos_to) &&
      !path_in_check?(pos_from, pos_to)
  end

  private

  def path_in_check?(pos_from, pos_to)
    king_path(pos_from, pos_to).any? { |move| piece_at(pos_from).move_into_check?(self, move) }
  end

  def path_empty?(pos_to)
    [BLACK_LONG, BLACK_SHORT, WHITE_LONG, WHITE_SHORT].each do |castle_path|
      return castle_path.none? { |pos| square_checked?(pos) } if castle_path.include?(pos_to)
    end

    false
  end

  def king_path(pos_from, pos_to)
    [position_between(pos_from, pos_to), pos_to]
  end

  def rook_positions(pos_from, pos_to)
    old_rook_file = rook_file(pos_to, ROOK_POSITIONS[-1][1], ROOK_POSITIONS[0][1])
    new_rook_file = rook_file(pos_to, BLACK_SHORT[0][1], BLACK_LONG[-1][1])
    [[pos_from.first, old_rook_file], [pos_from.first, new_rook_file]]
  end

  def rook_file(pos_to, king_side, queen_side)
    pos_to.last == SHORT_KING_FILE ? king_side : queen_side
  end
end
