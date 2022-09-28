# frozen_string_literal: true

class Player
  attr_reader :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def to_s
    @name
  end
end
