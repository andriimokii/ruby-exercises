# frozen_string_literal: true

require_relative '../../lib/pieces/stepping_piece'
require_relative '../../lib/board'

RSpec.describe SteppingPiece do
  subject(:stepping_piece) { described_class.new([0, 1], :black, 'N') }

  describe '#next_moves' do
    let(:board) { instance_double(Board) }
    let(:piece) { instance_double(Piece) }

    before do
      offsets = [[2, -1], [2, 1]]

      stub_const("#{described_class}::OFFSETS", offsets)
    end

    context 'when #move_verified? always true' do
      before do
        allow(stepping_piece).to receive(:move_verified?).and_return(true, true)
      end

      it 'returns all next moves' do
        result = stepping_piece.next_moves(board)
        expectation = [[2, 0], [2, 2]]

        expect(result).to eq(expectation)
      end
    end

    context 'when #move_verified? true, than false' do
      before do
        allow(stepping_piece).to receive(:move_verified?).and_return(true, false)
      end

      it 'returns one next moves' do
        result = stepping_piece.next_moves(board)
        expectation = [[2, 0]]

        expect(result).to eq(expectation)
      end
    end

    context 'when #move_verified? always false' do
      before do
        allow(stepping_piece).to receive(:move_verified?).and_return(false, false)
      end

      it 'returns no next moves' do
        result = stepping_piece.next_moves(board)

        expect(result).to be_empty
      end
    end
  end
end
