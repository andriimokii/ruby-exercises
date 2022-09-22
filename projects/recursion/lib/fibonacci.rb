# frozen_string_literal: true

def fibs(number)
  number.times.reduce([]) do |fib, index|
    fib << (index < 2 ? index : fib[index - 1] + fib[index - 2])
  end
end

def fibs_rec(number)
  number < 2 ? number : fibs_rec(number - 1) + fibs_rec(number - 2)
end

number = 8

# iteration
p fibs(number)

# recursion
result =
  number.times.reduce([]) do |fib, index|
    fib << fibs_rec(index)
  end

p result
