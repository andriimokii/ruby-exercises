require_relative 'player'

class MasterMind
  GUESS_COUNT = 12
  COLUMNS_COUNT = 4
  BALL_COLORS = %w[blue yellow orange white green].freeze
  COUNTER_COLORS = %w[white red].freeze

  attr_accessor :player, :code, :temp_ball, :guess_helper, :computer_guess

  def initialize
    @code = generate_code
    @temp_ball = 0
    @guess_helper = 0
    @computer_guess = []
  end

  def add_player(player)
    self.player = player
  end

  def start
    game_choice = get_game_choice

    if game_choice == 1
      puts "Random code: #{code}"
      1.upto(GUESS_COUNT) do |guess_count|
        user_guess = get_guess(guess_count)
        check_win(user_guess, guess_count)
        p guessed_counters(user_guess)
      end
    elsif game_choice == 0
      get_code

      1.upto(GUESS_COUNT) do |guess_count|
        if guess_count == 1
          self.computer_guess = generate_code
        end

        check_win(computer_guess, guess_count)
        guessed_counters = guessed_counters(computer_guess)
        change_computer_guess(guessed_counters)
      end
    end

    puts "Code was #{code}. You failed!"
  end

  private

  def get_game_choice
    print "#{player} is code-maker [0] or code-breaker [1]: "
    gets.chomp.to_i
  end

  def get_guess(guess_count)
    print "##{guess_count} Guess. Colors: "
    gets.chomp.split
  end

  def get_code
    print "generate code (eg. 'blue yellow orange white'): "
    self.code = gets.chomp.split
  end

  def generate_code
    BALL_COLORS.sample(COLUMNS_COUNT)
  end

  def check_win(user_guess, guess_count)
    if user_guess == code
      puts "Won with #{guess_count} guesses"
      exit
    end
  end

  def guessed_counters(user_guess)
    user_guess.each_with_index.reduce([]) do |result, (guess_ball, index)|
      if guess_ball == code[index]
        result << COUNTER_COLORS.last
      elsif code.include?(guess_ball)
        result << COUNTER_COLORS.first
      end

      result
    end
  end

  def change_computer_guess(guessed_counters)
    if guessed_counters.size == 3
      if temp_ball.nil?
        self.temp_ball = computer_guess[guess_helper]
        self.computer_guess[guess_helper] = (BALL_COLORS - computer_guess).join.to_s
      else
        self.temp_ball, self.computer_guess[guess_helper - 1], self.computer_guess[guess_helper] = computer_guess[guess_helper], temp_ball, computer_guess[guess_helper - 1]
      end
      self.guess_helper += 1
    else
      self.computer_guess.shuffle!
    end
  end
end

player = Player.new('Player Name')
game = MasterMind.new
game.add_player(player)
game.start