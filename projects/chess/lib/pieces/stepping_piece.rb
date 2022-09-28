# frozen_string_literal: true

require_relative 'piece'

class SteppingPiece < Piece
  def next_moves(board)
    self.class::OFFSETS.reduce([]) do |next_moves, offset|
      next_move = position.map.with_index { |pos, index| pos + offset[index] }
      next_moves << next_move if move_verified?(next_move, board)
      next_moves
    end
  end

  private

  def move_verified?(move, board)
    Board.on_board?(move) &&
      board.board[move.first][move.last][:piece]&.color != color
  end
end
