# frozen_string_literal: true

require_relative '../../lib/pieces/sliding_piece'
require_relative '../../lib/board'

RSpec.describe SlidingPiece do
  subject(:sliding_piece) { described_class.new([0, 0], :black, 'R') }

  describe '#next_moves' do
    let(:board) { instance_double(Board) }
    let(:moves_path_first) { [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]] }
    let(:moves_path_last) { [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]] }

    before do
      offsets = [[1, 0], [0, 1]]

      allow(sliding_piece).to receive(:moves_path).and_return(moves_path_first, moves_path_last)
      stub_const("#{described_class}::OFFSETS", offsets)
    end

    it 'returns next moves' do
      result = sliding_piece.next_moves(board)
      expect(result).to eq(moves_path_first + moves_path_last)
    end
  end
end
