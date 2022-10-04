# frozen_string_literal: true

require_relative '../../lib/pieces/king'

RSpec.describe King do
  subject(:king) { described_class.new([0, 4], :black, 'K') }

  describe '.to_unicode_symbol' do
    context 'when color white' do
      let(:color) { :white }
      let(:white_king_symbol) { "\u2654" }

      it 'returns white king symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(white_king_symbol)
      end
    end

    context 'when color black' do
      let(:color) { :black }
      let(:black_king_symbol) { "\u265A" }

      it 'returns black king symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(black_king_symbol)
      end
    end
  end

  describe '#position=' do
    let(:new_position) { [1, 4] }

    it 'changes @has_moved to true' do
      expect { king.position = new_position }.to change { king.has_moved }.from(false).to(true)
    end
  end
end
