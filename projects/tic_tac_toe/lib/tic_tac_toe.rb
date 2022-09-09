require_relative 'player'

class TicTacToe
  WIN_MOVES = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]].freeze

  attr_accessor :board, :players

  def initialize
    @board = Array.new(9) { { checked: nil, player: nil } }
    @players = []
  end

  def add_players(players)
    self.players = players
  end

  def start
    shuffled_players = players.shuffle

    loop do
      get_move(shuffled_players)
      format_board
      game_status = status(shuffled_players)

      if game_status[:win]
        puts "Game is over. #{shuffled_players.first} won the game."
        break
      elsif game_status[:draw]
        puts "Game is over. #{shuffled_players.first} has draw with #{shuffled_players.rotate.first}"
        break
      else
        shuffled_players.rotate!
      end
    end
  end

  private

  def get_move(shuffled_players)
    retries = 3
    print "#{shuffled_players.first} move: "

    begin
      move = gets.match(/[0-8]/)[0].to_i
    rescue
      if retries > 0
        puts "#{retries} left."
        retries -= 1
        retry
      else
        exit
      end
    else
      self.board[move] = { checked: true, player: shuffled_players.first }
    end
  end

  def format_board
    board.each_with_index do |cell, index|
      index % 3 == 2 ? puts("[#{cell[:player]&.mark}]") : print("[#{cell[:player]&.mark}]")
    end
  end

  def status(shuffled_players)
    win_status = WIN_MOVES.any? do |win_move|
      win_move.all? do |index|
        board[index][:checked] == true && board[index][:player] == shuffled_players.first
      end
    end

    draw_status = board.all? { |cell| cell[:checked] == true }

    { win: win_status, draw: draw_status }
  end
end

player_1 = Player.new('Player #1', 'x')
player_2 = Player.new('Player #2', 'o')
game = TicTacToe.new
game.add_players([player_1, player_2])
game.start