# frozen_string_literal: true

def stock_picker(array)
  array.each_with_index.reduce(Array.new(2, 0)) do |result, (stock, index)|
    max_sell = array[index..].max
    max_sell - stock > array[result.last] - array[result.first] ? [index, array.index(max_sell)] : result
  end
end
