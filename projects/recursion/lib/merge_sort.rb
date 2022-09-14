class MergeSort
  def sort(array)
    return array if array.size < 2

    merge(sort(array[0...array.size/2]), sort(array[array.size/2...array.size]))
  end

  private

  def merge(left_array, right_array)
    sorted_array = []

    until left_array.empty? || right_array.empty? do
      sorted_array << (left_array.first < right_array.first ? left_array.shift : right_array.shift)
    end

    sorted_array.concat(left_array, right_array)
  end
end

merge_sort = MergeSort.new
p merge_sort.sort([5,2,1,3,6,4])
