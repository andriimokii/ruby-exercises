require 'spec_helper'
require_relative '../lib/stock_picker'

RSpec.describe 'Stock picker' do
  describe '#stock_picker' do
    it 'works with a set of values' do
      expect(stock_picker([17,3,6,9,15,8,6,1,10])).to eql([1,4])
    end
  end
end
