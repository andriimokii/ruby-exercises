# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  attr_reader :has_moved

  def initialize(position, color = :white, short = 'P')
    super
    @has_moved = false
  end

  def position=(position)
    @position = position
    @has_moved = true
  end

  def self.straight_offsets(color)
    return [[-1, 0], [-2, 0]] if color == :white

    [[1, 0], [2, 0]]
  end

  def self.attack_offsets(color)
    return [[-1, -1], [-1, 1]] if color == :white

    [[1, -1], [1, 1]]
  end

  def to_unicode_symbol(color)
    color == :white ? "\u2659" : "\u265F"
  end

  def next_moves(board)
    next_straight_moves(board) + next_attack_moves(board)
  end

  def next_straight_moves(board)
    self.class.straight_offsets(color).reduce([]) do |next_moves, offset|
      next_move = position.map.with_index { |pos, index| pos + offset[index] }
      next_moves << next_move if straight_move_verified?(next_move, board, offset)
      next_moves
    end
  end

  def next_attack_moves(board)
    self.class.attack_offsets(color).reduce([]) do |next_moves, offset|
      next_move = position.map.with_index { |pos, index| pos + offset[index] }
      next_moves << next_move if attack_move_verified?(next_move, board)
      next_moves
    end
  end

  private

  def attack_move_verified?(move, board)
    Board.on_board?(move) &&
      board.square_checked?(move) &&
      board.board[move.first][move.last][:piece]&.color != color
  end

  def straight_move_verified?(move, board, offset)
    return false if !Board.on_board?(move) || board.square_checked?(move)
    return true if offset[0].abs == 1
    return true if offset[0].abs == 2 && !has_moved && !board.square_checked?(next_rank_move)

    false
  end

  def next_rank_move
    [position[0] + (color == :black ? 1 : -1), position[1]]
  end
end
