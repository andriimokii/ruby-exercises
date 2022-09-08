require 'spec_helper'
require_relative '../lib/bubble_sort'

RSpec.describe 'Bubble sort' do
  describe '#bubble_sort' do
    it 'works with unsorted array' do
      expect(bubble_sort([4,3,78,2,0,2])).to eql([0,2,2,3,4,78])
    end
  end
end
