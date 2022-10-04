# frozen_string_literal: true

require_relative '../../lib/pieces/queen'

RSpec.describe Queen do
  describe '.to_unicode_symbol' do
    context 'when color white' do
      let(:color) { :white }
      let(:white_queen_symbol) { "\u2655" }

      it 'returns white queen symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(white_queen_symbol)
      end
    end

    context 'when color black' do
      let(:color) { :black }
      let(:black_queen_symbol) { "\u265B" }

      it 'returns black queen symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(black_queen_symbol)
      end
    end
  end
end
