# frozen_string_literal: true

require_relative 'pieces/main'
require_relative 'modules/board_configurable'
require_relative 'modules/castling'

class Board
  include BoardConfigurable
  include Castling

  BOARD_SIZE = 8

  attr_accessor :players, :board

  def initialize(players)
    @players = players
    @board = Array.new(BOARD_SIZE) do
      Array.new(BOARD_SIZE) { self.class.nil_square }
    end
  end

  def self.on_board?(position)
    position.all? { |pos| pos.between?(0, 7) }
  end

  def self.to_coords(notation)
    [8 - notation[1].to_i, notation[0].ord - 97]
  end

  def square_checked?(pos)
    board[pos.first][pos.last][:checked].is_a?(TrueClass)
  end

  def move_verified?(player, pos_from, pos_to)
    return false unless player_color?(player, pos_from)
    return false unless move_in_list?(pos_from, pos_to) || (castle?(pos_from, pos_to) && can_castle?(pos_from, pos_to))

    true
  end

  def player_color?(player, pos)
    !piece_at(pos)&.color.nil? && piece_at(pos).color == player.color
  end

  def move_in_list?(pos_from, pos_to)
    piece_at(pos_from).valid_moves(self).include?(pos_to)
  end

  def piece_at(pos)
    board[pos.first][pos.last][:piece]
  end

  def player_at(pos)
    board[pos.first][pos.last][:player]
  end

  def move_piece(pos_from, pos_to)
    fill_square!(pos_to, player_at(pos_from), piece_at(pos_from))
    empty_square!(pos_from)
  end

  def fill_square!(pos, player, piece)
    piece.position = pos
    board[pos.first][pos.last] = { checked: true, player:, piece: }
  end

  def empty_square!(pos)
    board[pos.first][pos.last] = self.class.nil_square
  end

  def self.nil_square
    { checked: false, player: nil, piece: nil }
  end

  def display
    @board.flatten.each_with_index do |square, index|
      index % 8 == 7 ? puts("[#{square[:piece]}]") : print("[#{square[:piece]}]")
    end
  end

  def check?(color)
    king_pos = king_pos(color)
    enemy_color = color == :white ? :black : :white
    enemy_pieces = find_pieces(enemy_color)
    enemy_pieces.any? { |piece| piece.next_moves(self).include?(king_pos) }
  end

  def king_pos(color)
    pieces = find_pieces(color)
    king = pieces.find { |piece| piece.is_a?(King) }
    king&.position
  end

  def find_pieces(color)
    board.flatten.reduce([]) do |pieces, square|
      pieces << square[:piece] if square[:piece]&.color == color
      pieces
    end
  end

  def checkmate?(color)
    pieces = find_pieces(color)
    check?(color) && pieces.all? { |piece| piece.valid_moves(self).empty? }
  end

  def stalemate?(color)
    pieces = find_pieces(color)
    !check?(color) && pieces.all? { |piece| piece.valid_moves(self).empty? }
  end

  def make_turn(pos_from, pos_to)
    return castling(pos_from, pos_to) if castle?(pos_from, pos_to) && can_castle?(pos_from, pos_to)

    move_piece(pos_from, pos_to)
  end
end
