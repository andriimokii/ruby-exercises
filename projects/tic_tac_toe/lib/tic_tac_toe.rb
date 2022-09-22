# frozen_string_literal: true

require_relative 'player'

class TicTacToe
  WIN_MOVES = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]].freeze

  attr_accessor :board, :players

  def initialize(players = [], board = Array.new(9) { { checked: nil, player: nil } })
    @board = board
    @players = players
  end

  def start
    puts "Let's play a game called 'Tic Tac Toe'!"
    shuffle_players!
    turn_order until game_over?
  end

  def turn_order
    rotate_players!
    update_board(player_turn)
    display_board
  end

  def update_board(player_turn)
    board[player_turn] = { checked: true, player: players.first }
  end

  def player_turn
    loop do
      verified_input = verify_input(player_input)
      return verified_input.to_i if verified_input

      puts 'Input error!'
    end
  end

  def verify_input(number)
    number if number.match?(/^[0-8]$/)
  end

  def game_over?
    status = game_status
    display_status(status)
    status[:win] || status[:draw]
  end

  def game_status
    win_status = WIN_MOVES.any? do |win_move|
      win_move.all? do |index|
        board[index][:checked] == true && board[index][:player] == players.first
      end
    end

    draw_status = board.all? { |cell| cell[:checked] == true } && !win_status

    { win: win_status, draw: draw_status }
  end

  def shuffle_players!
    players.shuffle!
  end

  def rotate_players!
    players.rotate!
  end

  private

  def player_input
    print "#{players.first} move: "
    gets.chomp
  end

  def display_status(status)
    if status[:win]
      puts "Game is over. #{players.first} won the game."
    elsif status[:draw]
      puts "Game is over. #{players.first} has draw with #{players.last}"
    end
  end

  def display_board
    board.each_with_index do |cell, index|
      index % 3 == 2 ? puts("[#{cell[:player]&.mark}]") : print("[#{cell[:player]&.mark}]")
    end
  end
end

# player_1 = Player.new('Player #1', 'x')
# player_2 = Player.new('Player #2', 'o')
# game = TicTacToe.new
# game.players([player_1, player_2])
# game.start
