# frozen_string_literal: true

module PiecePositionable
  BISHOP_POSITIONS = [[7, 2], [0, 2], [7, 5], [0, 5]].freeze
  KING_POSITIONS = [[7, 4], [0, 4]].freeze
  KNIGHT_POSITIONS = [[7, 1], [0, 1], [7, 6], [0, 6]].freeze
  QUEEN_POSITIONS = [[7, 3], [0, 3]].freeze
  ROOK_POSITIONS = [[7, 0], [0, 0], [7, 7], [0, 7]].freeze
  PAWN_POSITIONS = [6].product(8.times.to_a).zip([1].product(8.times.to_a)).flatten(1).freeze
end
