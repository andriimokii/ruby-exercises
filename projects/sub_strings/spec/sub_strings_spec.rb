require 'spec_helper'
require_relative '../lib/sub_strings'

RSpec.describe 'Sub strings' do
  describe '#substrings' do
    it 'can handle multiple words with case insensitive' do
      dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
      sentence = "Howdy partner, sit down! How's it going?"
      result = { "down" => 1, "go" => 1, "going" => 1, "how" => 2, "howdy" => 1, "it" => 2, "i" => 3, "own" => 1, "part" => 1, "partner" => 1, "sit" => 1 }

      expect(substrings(sentence, dictionary)).to eql(result)
    end
  end
end
