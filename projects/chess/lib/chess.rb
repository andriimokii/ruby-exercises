# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'modules/serializable'

class Chess
  include Serializable

  attr_accessor :players, :board

  def initialize(players)
    @players = players
    @board = Board.new(players)
  end

  def start
    puts "Let's play a game called 'Chess'!"

    if load_game?
      chess = load_game
      self.board = chess.board
      self.players = chess.players
    else
      board.place_pieces
    end

    board.display_board
    turn_order until game_over?
  end

  private

  def turn_order
    board.make_turn(*player_turn)
    board.display_board
    rotate_players!
    display_message(players.first)
  end

  def game_over?
    board.checkmate?(players.first.color) || board.stalemate?(players.first.color)
  end

  def player_turn
    loop do
      verified_input = verify_input(player_input)

      return verified_input if verified_input

      puts 'Input error!'
    end
  end

  def verify_input(input)
    return unless !input.nil? && input_on_board?(input) && board.move_verified?(players.first, *input)

    input
  end

  def input_on_board?(input)
    input.all? { |position| Board.on_board?(position) }
  end

  def rotate_players!
    players.rotate!
  end

  def player_input
    print "#{players.first} (#{players.first.color}) move: "
    from_notation, to_notation = *gets.chomp.split

    exit if from_notation.downcase == 'q'
    return save_game if from_notation.downcase == 's'

    [Board.to_coords(from_notation), Board.to_coords(to_notation)]
  end

  def display_message(player)
    if board.checkmate?(player.color)
      puts "Checkmate for #{player} (#{player.color})"
    elsif board.check?(player.color)
      puts "Check for #{player} (#{player.color})"
    elsif board.stalemate?(player.color)
      puts "Stalemate for #{player} (#{player.color})"
    end
  end
end

player_1 = Player.new('Player #1', :white)
player_2 = Player.new('Player #2', :black)
game = Chess.new([player_1, player_2])
game.start
