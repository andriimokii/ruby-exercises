# frozen_string_literal: true

require_relative 'piece_positionable'

module BoardFillable
  COLOR = %i[white black].freeze

  def place_pieces
    PiecePositionable.constants.each do |const|
      place(PiecePositionable.const_get(const),
            Object.const_get(const.to_s.split('_').first.capitalize))
    end
  end

  private

  def place(positions, class_name)
    positions.each_with_index do |pos, index|
      rank = pos.first
      file = pos.last
      board[rank][file] = { checked: true,
                            player: players[index % players.size],
                            piece: class_name.new([rank, file], COLOR[index % COLOR.size]) }
    end
  end
end
