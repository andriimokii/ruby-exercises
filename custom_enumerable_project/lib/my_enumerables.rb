module Enumerable
  # Your code goes here
  def my_each_with_index
    return unless block_given?

    self.size.times do |index|
      yield self[index], index
    end

    self
  end

  def my_select
    return unless block_given?

    array = []
    self.my_each do |item|
      array << item if yield item
    end

    array
  end

  def my_all?
    return unless block_given?

    self.my_each do |item|
      return false unless yield item
    end

    true
  end

  def my_any?
    return unless block_given?

    self.my_each do |item|
      return true if yield item
    end

    false
  end

  def my_none?
    return unless block_given?

    self.my_each do |item|
      return false if yield item
    end

    true
  end

  def my_count
    return self.size unless block_given?

    count = 0
    self.my_each do |item|
      count += 1 if yield item
    end

    count
  end

  def my_map
    return unless block_given?

    array = []
    self.my_each do |item|
      array << yield(item)
    end

    array
  end

  def my_inject(initial_value)
    return unless block_given?

    memo = initial_value
    self.my_each do |item|
      memo = yield(memo, item)
    end

    memo
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    return unless block_given?

    for item in self do
      yield item
    end
  end
end
