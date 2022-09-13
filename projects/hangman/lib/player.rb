require_relative 'basic_serializable'

class Player
  include BasicSerializable

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end
end