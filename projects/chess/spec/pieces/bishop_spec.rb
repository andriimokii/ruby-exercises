# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'

RSpec.describe Bishop do
  describe '.to_unicode_symbol' do
    context 'when color white' do
      let(:color) { :white }
      let(:white_bishop_symbol) { "\u2657" }

      it 'returns white bishop symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(white_bishop_symbol)
      end
    end

    context 'when color black' do
      let(:color) { :black }
      let(:black_bishop_symbol) { "\u265D" }

      it 'returns black bishop symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(black_bishop_symbol)
      end
    end
  end
end
