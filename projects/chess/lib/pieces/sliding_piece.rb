# frozen_string_literal: true

require_relative 'piece'

class SlidingPiece < Piece
  def next_moves(board)
    self.class::OFFSETS.reduce([]) do |next_moves, offset|
      next_moves += moves_path(offset, board)
      next_moves
    end
  end

  private

  def moves_path(offset, board)
    moves_path = []
    factor = 1

    loop do
      move = get_move(offset, factor)

      break unless Board.on_board?(move)

      moves_path << move if move_verified?(move, board)

      break if board.square_checked?(move)

      factor += 1
    end

    moves_path
  end

  def get_move(offset, factor)
    new_offset = offset.map { |i| i * factor }
    position.map.with_index { |pos, index| pos + new_offset[index] }
  end

  def move_verified?(move, board)
    return true unless board.square_checked?(move)

    board.square_checked?(move) && board.board[move.first][move.last][:piece].color != color
  end
end
