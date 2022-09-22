# frozen_string_literal: true

require_relative 'player'

class ConnectFour
  WIN_MOVES = [[0, 1, 2, 3], [41, 40, 39, 38], [7, 8, 9, 10], [34, 33, 32, 31], [14, 15, 16, 17], [27, 26, 25, 24],
               [21, 22, 23, 24], [20, 19, 18, 17], [28, 29, 30, 31], [13, 12, 11, 10], [35, 36, 37, 38], [6, 5, 4, 3], [0, 7, 14, 21], [41, 34, 27, 20], [1, 8, 15, 22], [40, 33, 26, 19], [2, 9, 16, 23], [39, 32, 25, 18], [3, 10, 17, 24], [38, 31, 24, 17], [4, 11, 18, 25], [37, 30, 23, 16], [5, 12, 19, 26], [36, 29, 22, 15], [6, 13, 20, 27], [35, 28, 21, 14], [0, 8, 16, 24], [41, 33, 25, 17], [7, 15, 23, 31], [34, 26, 18, 10], [14, 22, 30, 38], [27, 19, 11, 3], [35, 29, 23, 17], [6, 12, 18, 24], [28, 22, 16, 10], [13, 19, 25, 31], [21, 15, 9, 3], [20, 26, 32, 38], [36, 30, 24, 18], [5, 11, 17, 23], [37, 31, 25, 19], [4, 10, 16, 22], [2, 10, 18, 26], [39, 31, 23, 15], [1, 9, 17, 25], [40, 32, 24, 16], [9, 17, 25, 33], [8, 16, 24, 32], [11, 17, 23, 29], [12, 18, 24, 30], [1, 2, 3, 4], [5, 4, 3, 2], [8, 9, 10, 11], [12, 11, 10, 9], [15, 16, 17, 18], [19, 18, 17, 16], [22, 23, 24, 25], [26, 25, 24, 23], [29, 30, 31, 32], [33, 32, 31, 30], [36, 37, 38, 39], [40, 39, 38, 37], [7, 14, 21, 28], [8, 15, 22, 29], [9, 16, 23, 30], [10, 17, 24, 31], [11, 18, 25, 32], [12, 19, 26, 33], [13, 20, 27, 34]].freeze

  attr_accessor :players, :board

  def initialize(players = [], board = Array.new(42) { { checked: false, player: nil } })
    @players = players
    @board = board
  end

  def start
    puts "Let's play a game called 'Connect four'!"
    shuffle_players!
    turn_order until game_over?
  end

  def turn_order
    rotate_players!
    update_board(player_turn)
    display_board
  end

  def update_board(player_turn)
    return if heap_peak?(player_turn)

    board[get_board_index(player_turn)] = { checked: true, player: players.first }
  end

  def get_board_index(player_turn, items_per_row = 7)
    until heap_peak?(player_turn + items_per_row) || board_cell_nil?(player_turn + items_per_row)
      player_turn += items_per_row
    end

    player_turn
  end

  def heap_peak?(player_turn)
    board[player_turn][:checked]
  end

  def board_cell_nil?(player_turn)
    board[player_turn].nil?
  end

  def player_turn
    loop do
      verified_input = verify_input(player_input)
      return verified_input.to_i if verified_input

      puts 'Input error!'
    end
  end

  def verify_input(number)
    number if number.match?(/^[0-6]$/)
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
      index % 7 == 6 ? puts("[#{cell[:player]&.mark}]") : print("[#{cell[:player]&.mark}]")
    end
  end
end

# player_1 = Player.new('Player #1', "\u26AA")
# player_2 = Player.new('Player #2', "\u26AB")
# game = ConnectFour.new([player_1, player_2])
# game.start
