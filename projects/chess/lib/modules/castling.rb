# frozen_string_literal: true

module Castling
  BLACK_LONG = [[0, 1], [0, 2], [0, 3]].freeze
  BLACK_SHORT = [[0, 5], [0, 6]].freeze
  WHITE_LONG = [[7, 1], [7, 2], [7, 3]].freeze
  WHITE_SHORT = [[7, 5], [7, 6]].freeze

  LONG_OFFSET = [0, -2].freeze
  SHORT_OFFSET = [0, 2].freeze

  def castle?(pos_from, pos_to)
    piece_at(pos_from).is_a?(King) && pos_from.map.with_index { |pos, index| (pos - pos_to[index]).abs } == [0, 2]
  end

  def castling(pos_from, pos_to)
    move_piece(pos_from, pos_to)
    move_piece([pos_from.first, old_rook_file(pos_to)], [pos_from.first, new_rook_file(pos_to)])
  end

  def can_castle?(pos_from, pos_to)
    !check?(player_at(pos_from).color) &&
      !piece_at(pos_from).has_moved &&
      !piece_at([pos_to.first, old_rook_file(pos_to)]).has_moved &&
      path_empty?(pos_to) &&
      !path_in_check?(pos_from, pos_to)
  end

  def path_in_check?(pos_from, pos_to)
    castle_path(pos_from, pos_to).any? { |move| piece_at(pos_from).move_into_check?(self, move) }
  end

  def path_empty?(pos_to)
    if BLACK_LONG.include?(pos_to)
      BLACK_LONG.none? { |pos| square_checked?(pos) }
    elsif BLACK_SHORT.include?(pos_to)
      BLACK_SHORT.none? { |pos| square_checked?(pos) }
    elsif WHITE_LONG.include?(pos_to)
      WHITE_LONG.none? { |pos| square_checked?(pos) }
    elsif WHITE_SHORT.include?(pos_to)
      WHITE_SHORT.none? { |pos| square_checked?(pos) }
    end
  end

  def castle_path(pos_from, pos_to)
    pos_between = pos_from.map.with_index { |pos, index| (pos + pos_to[index]) / 2 }
    [pos_between, pos_to]
  end

  def old_rook_file(pos_to)
    king_side = 7
    queen_side = 0
    pos_to.last == 6 ? king_side : queen_side
  end

  def new_rook_file(pos_to)
    king_side = 5
    queen_side = 3
    pos_to.last == 6 ? king_side : queen_side
  end
end
