# frozen_string_literal: true

require_relative 'pieces/pawn'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'modules/board_fillable'
require_relative 'modules/castlable'
require_relative 'modules/en_passantable'
require_relative 'modules/promotionable'

class Board
  include BoardFillable
  include Castlable
  include EnPassantable
  include Promotionable

  COLOR = %i[white black].freeze
  BOARD_SIZE = 8
  LOWERCASE_A_ORDINAL = 97

  attr_accessor :players, :board, :previous_piece

  def self.on_board?(position)
    position.all? { |pos| pos.between?(0, BOARD_SIZE - 1) }
  end

  def self.to_coords(notation)
    [BOARD_SIZE - notation[1].to_i, notation[0].ord - LOWERCASE_A_ORDINAL]
  end

  def self.nil_square
    { checked: false, player: nil, piece: nil }
  end

  def initialize(players)
    @players = players
    @previous_piece = nil
    @board = Array.new(BOARD_SIZE) do
      Array.new(BOARD_SIZE) { self.class.nil_square }
    end
  end

  def square_checked?(pos)
    board[pos.first][pos.last][:checked].is_a?(TrueClass)
  end

  def move_verified?(player, pos_from, pos_to)
    return false unless player_color?(player, pos_from)
    unless move_in_list?(pos_from, pos_to) ||
           castle_verified?(pos_from, pos_to) ||
           en_passant_verified?(pos_from, pos_to)
      return false
    end

    true
  end

  def move_piece!(pos_from, pos_to)
    fill_square!(pos_to, player_at(pos_from), piece_at(pos_from))
    empty_square!(pos_from)
  end

  def display_board
    board.flatten.each_with_index do |square, index|
      piece = square[:piece]
      index % BOARD_SIZE == BOARD_SIZE - 1 ? puts(format_square(piece)) : print(format_square(piece))
    end
  end

  def check?(color)
    king_pos = king_pos(color)
    enemy_color = color == COLOR.first ? COLOR.last : COLOR.first
    enemy_pieces = find_pieces(enemy_color)
    enemy_pieces.any? { |piece| piece.next_moves(self).include?(king_pos) }
  end

  def checkmate?(color)
    pieces = find_pieces(color)
    check?(color) && valid_moves_none?(pieces)
  end

  def stalemate?(color)
    pieces = find_pieces(color)
    !check?(color) && valid_moves_none?(pieces)
  end

  def make_turn(pos_from, pos_to)
    return castle(pos_from, pos_to) if castle_verified?(pos_from, pos_to)
    return en_passant(pos_from, pos_to) if en_passant_verified?(pos_from, pos_to)
    return promote(pos_from, pos_to) if promote_verified?(pos_from, pos_to)

    move_piece!(pos_from, pos_to)
    change_previous_piece!(pos_to)
  end

  def same_color?(pos, obj)
    piece_at(pos)&.color == obj.color
  end

  private

  def player_color?(player, pos)
    !piece_at(pos)&.color.nil? && same_color?(pos, player)
  end

  def move_in_list?(pos_from, pos_to)
    piece_at(pos_from).valid_moves(self).include?(pos_to)
  end

  def format_square(piece)
    "[#{piece}]"
  end

  def king_pos(color)
    pieces = find_pieces(color)
    king = pieces.find { |piece| piece.is_a?(King) }
    king&.position
  end

  def piece_at(pos)
    board[pos.first][pos.last][:piece]
  end

  def player_at(pos)
    board[pos.first][pos.last][:player]
  end

  def fill_square!(pos, player, piece)
    piece.position = pos
    board[pos.first][pos.last] = { checked: true, player:, piece: }
  end

  def empty_square!(pos)
    board[pos.first][pos.last] = self.class.nil_square
  end

  def find_pieces(color)
    board.flatten.each_with_object([]) do |square, pieces|
      piece = square[:piece]
      pieces << piece if piece&.color == color
    end
  end

  def valid_moves_none?(pieces)
    pieces.all? { |piece| piece.valid_moves(self).empty? }
  end

  def pos_offset(pos_from, pos_to)
    pos_from.map.with_index { |pos, index| (pos - pos_to[index]).abs }
  end

  def piece_moved?(pos)
    piece_at(pos).has_moved.is_a?(TrueClass)
  end

  def piece_type_at_position?(pos, class_name)
    piece_at(pos).is_a?(class_name)
  end

  def position_between(pos_from, pos_to)
    pos_from.map.with_index { |pos, index| (pos + pos_to[index]) / 2 }
  end

  def change_previous_piece!(pos)
    self.previous_piece = piece_at(pos)
  end
end
