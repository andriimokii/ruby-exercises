require 'spec_helper'
require_relative '../lib/caesar_cipher'

RSpec.describe 'Caesar cipher' do
  describe '#caesar_cipher' do
    it 'works with small positive shift' do
      expect(caesar_cipher('Zz', 5)).to eql('Ee')
    end

    it 'works with small negative shift' do
      expect(caesar_cipher('Ee', -5)).to eql('Zz')
    end

    it 'works with large positive shift' do
      expect(caesar_cipher('Zz', 83)).to eql('Ee')
    end

    it 'works with large negative shift' do
      expect(caesar_cipher('Ee', -83)).to eql('Zz')
    end

    it 'works with a phrase with punctuation' do
      expect(caesar_cipher('What a string!', 5)).to eql('Bmfy f xywnsl!')
    end

    it 'works with a phrase with a large shift' do
      expect(caesar_cipher('Hello, World!', 75)).to eql('Ebiil, Tloia!')
    end

    it 'works with a phrase with a large negative shift' do
      expect(caesar_cipher('Hello, World!', -55)).to eql('Ebiil, Tloia!')
    end
  end
end
