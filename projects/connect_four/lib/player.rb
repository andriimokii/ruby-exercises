# frozen_string_literal: true

class Player
  attr_reader :mark

  def initialize(name, mark)
    @name = name
    @mark = mark
  end

  def to_s
    @name
  end
end
