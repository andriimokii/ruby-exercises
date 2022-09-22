# frozen_string_literal: true

class Computer
  @@users = {}
  def initialize(username, password)
    @username = username
    @password = password
    @files = {}
    @@users[username] = password
  end

  def create(filename)
    time = Time.now
    @files[filename] = time
    puts "#{filename} #{@username} #{time}"
  end

  def self.get_users
    @@users
  end
end

my_computer = Computer.new('username', 'password')
