# frozen_string_literal: true

module Promotion
  def promote_verified?(pos_from, pos_to)
    piece_at(pos_from).is_a?(Pawn) && promotion_rank?(pos_to.first, piece_at(pos_from).color)
  end

  def promotion_rank?(rank, color)
    (color == :white && rank.zero?) || (color == :black && rank == 7)
  end

  def promote(pos_from, pos_to)
    choice = select_promotion_piece
    create_promotion_piece!(choice, pos_from, pos_to)
    empty_square!(pos_from)
  end

  def select_promotion_piece
    loop do
      verified_promotion_piece = verify_promotion_piece(promotion_piece_input)
      return verified_promotion_piece if verified_promotion_piece

      puts 'Input error! Only enter 1-digit (0-3).'
    end
  end

  def promotion_piece_input
    display_promotion_choices
    gets.chomp
  end

  def verify_promotion_piece(input)
    return unless input.match?(/^[0-3]$/)

    input
  end

  def create_promotion_piece!(choice, pos_from, pos_to)
    player = player_at(pos_from)
    color = piece_at(pos_from).color

    case choice.to_i
    when 0
      fill_square!(pos_to, player, Queen.new(pos_to, color))
    when 1
      fill_square!(pos_to, player, Bishop.new(pos_to, color))
    when 2
      fill_square!(pos_to, player, Knight.new(pos_to, color))
    else
      fill_square!(pos_to, player, Rook.new(pos_to, color))
    end
  end

  private

  def display_promotion_choices
    puts <<~HEREDOC
      To promote your pawn, enter one of the following numbers:
        [0] for a Queen
        [1] for a Bishop
        [2] for a Knight
        [3] for a Rook
    HEREDOC
  end
end
