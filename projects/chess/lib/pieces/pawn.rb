# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  PASSANT_RANK_OFFSET = 2
  WHITE_NEXT_RANK_OFFSET = -1
  BLACK_NEXT_RANK_OFFSET = 1
  SINGLE_STRAIGHT_OFFSET = 1
  DOUBLE_STRAIGHT_OFFSET = 2
  WHITE_STRAIGHT_OFFSETS = [[-1, 0], [-2, 0]].freeze
  BLACK_STRAIGHT_OFFSETS = [[1, 0], [2, 0]].freeze
  WHITE_ATTACK_OFFSETS = [[-1, -1], [-1, 1]].freeze
  BLACK_ATTACK_OFFSETS = [[1, -1], [1, 1]].freeze

  attr_reader :has_moved, :en_passant

  def self.to_unicode_symbol(color)
    color == COLOR.first ? "\u2659" : "\u265F"
  end

  def self.straight_offsets(color)
    return WHITE_STRAIGHT_OFFSETS if color == COLOR.first

    BLACK_STRAIGHT_OFFSETS
  end

  def self.attack_offsets(color)
    return WHITE_ATTACK_OFFSETS if color == COLOR.first

    BLACK_ATTACK_OFFSETS
  end

  def initialize(position, color = :white, short = 'P')
    super
    @has_moved = false
    @en_passant = false
  end

  def position=(position)
    @en_passant = en_passant?(position)
    @position = position
    @has_moved = true
  end

  def next_moves(board)
    next_straight_moves(board) + next_attack_moves(board)
  end

  def next_straight_moves(board)
    self.class.straight_offsets(color).each_with_object([]) do |offset, next_moves|
      next_move = position.map.with_index { |pos, index| pos + offset[index] }
      next_moves << next_move if straight_move_verified?(next_move, board, offset)
    end
  end

  def next_attack_moves(board)
    self.class.attack_offsets(color).each_with_object([]) do |offset, next_moves|
      next_move = position.map.with_index { |pos, index| pos + offset[index] }
      next_moves << next_move if attack_move_verified?(next_move, board)
    end
  end

  private

  def en_passant?(pos)
    (position.first - pos.first).abs == PASSANT_RANK_OFFSET
  end

  def attack_move_verified?(move, board)
    Board.on_board?(move) &&
      board.square_checked?(move) &&
      !board.same_color?(move, self)
  end

  def straight_move_verified?(move, board, offset)
    return false if !Board.on_board?(move) || board.square_checked?(move)
    return true if offset[0].abs == SINGLE_STRAIGHT_OFFSET
    return true if offset[0].abs == DOUBLE_STRAIGHT_OFFSET && !has_moved && !board.square_checked?(next_rank_move)

    false
  end

  def next_rank_move
    next_rank_offset = (color == COLOR.last ? BLACK_NEXT_RANK_OFFSET : WHITE_NEXT_RANK_OFFSET)
    [position.first + next_rank_offset, position.last]
  end
end
