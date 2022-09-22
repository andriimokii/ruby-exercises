# frozen_string_literal: true

def substrings(sentence, dictionary)
  sentence.downcase.split.each_with_object(Hash.new(0)) do |word, result|
    dictionary.each do |key|
      result[key] += 1 if word.include?(key)
    end
  end
end
