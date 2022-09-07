def substrings(sentence, dictionary)
  sentence.downcase.split.reduce(Hash.new(0)) do |result, word|
    dictionary.each do |key|
      result[key] += 1 if word.include?(key)
    end

    result
  end
end
