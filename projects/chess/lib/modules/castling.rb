# frozen_string_literal: true

module Castling
  def castle(side)
    case side
    when :king
      kingside_castling
    when :queen
      queenside_castling
    else
      puts 'Error'
    end
  end

  def kingside_castling
    return unless can_castle?
  end

  def queenside_castling
    return unless can_castle?
  end

  def can_castle?

  end
end
