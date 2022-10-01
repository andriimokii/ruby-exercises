# frozen_string_literal: true

module Serializable
  def save_game
    Dir.mkdir 'saved_games' unless Dir.exist? 'saved_games'
    filename = Time.now.strftime('%Y%m%dT%H%M%S')

    File.open("saved_games/#{filename}", 'w') do |file|
      Marshal.dump(self, file)
    end

    puts "Game was saved as #{filename}"
  end

  def load_game?
    puts 'Load the game?[yn]'
    return true if gets.chomp.downcase == 'y'

    false
  end

  def load_game
    file_name = find_saved_file

    File.open("saved_games/#{file_name}") do |file|
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
    return [] unless Dir.exist? 'saved_games'

    Dir.children('saved_games')
  end

  def print_saved_games(game_list)
    puts 'File Name(s):'
    game_list.each_with_index do |name, index|
      puts "[#{index}] #{name}"
    end
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
