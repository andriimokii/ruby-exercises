require_relative 'basic_serializable'
require_relative 'player'

class Hangman
  include BasicSerializable

  attr_accessor :word, :player, :correct_letters, :incorrect_letters, :counter

  def initialize
    @word = get_file_content.grep(/\w{5,12}/).sample
    @correct_letters = []
    @incorrect_letters = []
    @counter = 6
  end

  def add_player(player)
    self.player = player
  end

  def start
    get_snapshot
    puts "Word generated: #{word}"

    loop do
      save_game
      print "#{player}, choose a char: "
      user_char = gets.chomp.downcase
      check_char(user_char)
      display_hidden_chars
      puts "Tries left: #{counter}. Incorrect letters: #{incorrect_letters}"
      check_game_status(counter)
    end
  end

  private

  def check_game_status(counter)
    if word.split('').uniq.length == correct_letters.uniq.length
      puts "#{player} won the game."
      exit
    elsif counter.zero?
      puts "#{player} lost the game."
      exit
    end
  end

  def get_file_content
    File.open('google_10000_english_no_swears.txt').readlines(chomp: true)
  end

  def get_snapshot
    if Dir.exist?('game_snapshots') && !Dir.empty?('game_snapshots')
      puts 'Do you want to continue from saved game? [y]'
      if gets.chomp.downcase == 'y'
        puts "Choose game snapshot: #{Dir.children('game_snapshots')}"
        snapshot_name = gets.chomp
        Dir.chdir('game_snapshots')
        if File.exist?(snapshot_name)
          contents = File.open(snapshot_name).readline(chomp: true)
          p contents
          unserialize(contents)
        end
      end
    end
  end

  def save_game
    puts "Save the game? [y]: "
    if gets.chomp.downcase == 'y'
      Dir.mkdir('game_snapshots') unless Dir.exist?('game_snapshots')
      Dir.chdir('game_snapshots')
      File.open("#{Time.now.strftime('%Y%m%d%H%M%S')}.txt", 'w') { |file| file.puts serialize }
    end
  end

  def check_char(user_char)
    if word.index(user_char).nil?
      self.counter -= 1
      self.incorrect_letters << user_char
    else
      self.correct_letters << user_char
    end
  end

  def display_hidden_chars
    puts word.tr((word.split('').uniq - correct_letters).join, '_')
  end

  def serialize
    obj = instance_variables.reduce({}) do |obj, var|
      obj[var] = var == :@player ? self.player.serialize : instance_variable_get(var)
      obj
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.parse string

    obj.each do |key, value|
      if key == '@player'
        player = Player.new('')
        player.unserialize(value)
        self.player = player
      else
        instance_variable_set(key, value)
      end
    end
  end
end

player = Player.new('Player #1')
game = Hangman.new
game.add_player(player)
game.start
