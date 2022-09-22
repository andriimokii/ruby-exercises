# frozen_string_literal: true

def bubble_sort(array)
  size = array.size

  loop do
    is_swapped = false

    1.upto(size - 1) do |index|
      if array[index - 1] > array[index]
        array[index - 1], array[index] = array[index], array[index - 1]
        is_swapped = true
      end
    end

    break unless is_swapped
  end

  array
end
