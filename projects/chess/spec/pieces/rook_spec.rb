# frozen_string_literal: true

require_relative '../../lib/pieces/rook'

RSpec.describe Rook do
  subject(:rook) { described_class.new([0, 0], :black, 'R') }

  describe '.to_unicode_symbol' do
    context 'when color white' do
      let(:color) { :white }
      let(:white_rook_symbol) { "\u2656" }

      it 'returns white rook symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(white_rook_symbol)
      end
    end

    context 'when color black' do
      let(:color) { :black }
      let(:black_rook_symbol) { "\u265C" }

      it 'returns black rook symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(black_rook_symbol)
      end
    end
  end

  describe '#position=' do
    let(:new_position) { [1, 0] }

    it 'changes @has_moved to true' do
      expect { rook.position = new_position }.to change { rook.has_moved }.from(false).to(true)
    end
  end
end
