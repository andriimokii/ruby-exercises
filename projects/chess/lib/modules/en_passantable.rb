# frozen_string_literal: true

module EnPassantable
  COLOR = %i[white black].freeze
  FILE_OFFSET = 1
  WHITE_RANK = 3
  BLACK_RANK = 4

  def en_passant(pos_from, pos_to)
    empty_square!(previous_piece.position)
    move_piece(pos_from, pos_to)
  end

  def en_passant_verified?(pos_from, pos_to)
    return false if previous_piece.nil?

    file_offset = pos_offset(pos_from, previous_piece.position).last

    en_passant_rank?(pos_from) &&
      previous_piece.is_a?(Pawn) &&
      piece_type_at_position?(pos_from, Pawn) &&
      file_offset == FILE_OFFSET &&
      previous_piece.en_passant &&
      en_passant_move_verified?(pos_from, pos_to)
  end

  private

  def en_passant_rank?(pos_from)
    rank = pos_from.first
    color = player_at(pos_from)&.color
    (rank == WHITE_RANK && color == COLOR.first) || (rank == BLACK_RANK && color == COLOR.last)
  end

  def en_passant_move_verified?(pos_from, pos_to)
    temp_board = remove_captured_pawn(previous_piece.position)

    !piece_at(pos_from).move_into_check?(temp_board, pos_to)
  end

  def remove_captured_pawn(pawn_location)
    temp_board = Marshal.load(Marshal.dump(self))
    temp_board.empty_square!(pawn_location)
    temp_board
  end
end
