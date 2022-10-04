# frozen_string_literal: true

require_relative '../../lib/pieces/knight'

RSpec.describe Knight do
  describe '.to_unicode_symbol' do
    context 'when color white' do
      let(:color) { :white }
      let(:white_knight_symbol) { "\u2658" }

      it 'returns white knight symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(white_knight_symbol)
      end
    end

    context 'when color black' do
      let(:color) { :black }
      let(:black_knight_symbol) { "\u265E" }

      it 'returns black knight symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(black_knight_symbol)
      end
    end
  end
end
