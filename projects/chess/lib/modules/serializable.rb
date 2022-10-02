# frozen_string_literal: true

module Serializable
  DIR_NAME = 'saved_games'
  FILE_NAME_FORMAT = '%Y%m%dT%H%M%S'

  def save_game
    create_dir
    serialize_to_file(filename)
    puts "Game was saved as #{filename}"
  end

  def load_game
    deserialize_from_file(find_saved_file)
  end

  def load_game?
    puts 'Load the game?[yn]'
    return true if gets.chomp.downcase == 'y'

    false
  end

  private

  def create_dir
    Dir.mkdir DIR_NAME unless Dir.exist? DIR_NAME
  end

  def filename
    Time.now.strftime(FILE_NAME_FORMAT)
  end

  def serialize_to_file(filename)
    File.open("#{DIR_NAME}/#{filename}", 'w') do |file|
      Marshal.dump(self, file)
    end
  end

  def deserialize_from_file(filename)
    File.open("#{DIR_NAME}/#{filename}") do |file|
      Marshal.load(file)
    end
  end

  def find_saved_file
    saved_games = game_list
    if saved_games.empty?
      puts 'There are no saved games to play yet!'
      exit
    else
      print_saved_games(saved_games)
      file_number = select_saved_game(saved_games.size)
      saved_games[file_number.to_i]
    end
  end

  def game_list
    return [] unless Dir.exist? DIR_NAME

    Dir.children(DIR_NAME)
  end

  def print_saved_games(game_list)
    puts 'File Name(s):'
    game_list.each_with_index do |name, index|
      puts saved_games_format(index, name)
    end
  end

  def saved_games_format(index, name)
    "[#{index}] #{name}"
  end

  def select_saved_game(saves_count)
    loop do
      file_number = verify_file_number(gets.chomp, saves_count)
      return file_number if file_number

      puts 'Input error! Enter a valid file number.'
    end
  end

  def verify_file_number(input, saves_count)
    return unless input.to_i.between?(0, saves_count - 1)

    input
  end
end
