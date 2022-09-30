# frozen_string_literal: true

module EnPassant
  def en_passant(pos_from, pos_to)
    pawn_position = previous_piece.position
    empty_square!(pawn_position)
    move_piece(pos_from, pos_to)
  end

  def en_passant_verified?(pos_from, pos_to)
    en_passant_rank?(pos_from) &&
      previous_piece.is_a?(Pawn) &&
      piece_at(pos_from).is_a?(Pawn) &&
      (pos_from.last - previous_piece.position.last).abs == 1 &&
      previous_piece.en_passant &&
      en_passant_move_verified?(pos_from, pos_to)
  end

  def en_passant_rank?(pos_from)
    rank = pos_from[0]
    color = player_at(pos_from)&.color
    (rank == 4 && color == :black) || (rank == 3 && color == :white)
  end

  def en_passant_move_verified?(pos_from, pos_to)
    pawn_position = previous_piece.position
    temp_board = remove_captured_en_passant_pawn(pawn_position)

    !piece_at(pos_from).move_into_check?(temp_board, pos_to)
  end

  def remove_captured_en_passant_pawn(pawn_location)
    temp_board = Marshal.load(Marshal.dump(self))
    temp_board.board[pawn_location.first][pawn_location.last] = self.class.nil_square
    temp_board
  end
end
