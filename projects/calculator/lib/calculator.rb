# frozen_string_literal: true

class Calculator
  def add(*nums)
    nums.sum
  end

  def multiply(*nums)
    nums.reduce { |result, num| result * num }
  end

  def subtract(a, b)
    a - b
  end

  def divide(a, b)
    a / b.to_f
  end
end
