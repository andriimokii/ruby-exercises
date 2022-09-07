def stock_picker(array)
  result = [0, 0]

  array.each_with_index do |stock, index|
    max_sell = array[index..].max
    if max_sell - stock > array[result[1]] - array[result[0]]
      result[0], result[1] = index, array.index(max_sell)
    end
  end

  result
end
