# frozen_string_literal: true

require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Piece do
  subject(:piece) { described_class.new([1, 0], :black, 'P') }

  describe '#to_s' do
    let(:unicode_symbol) { '\u2659' }

    before do
      allow(described_class).to receive(:to_unicode_symbol).and_return(unicode_symbol)
    end

    it 'prints object as unicode symbol' do
      result = piece.to_s
      expect(result).to eq(unicode_symbol)
    end
  end

  describe '#valid_moves' do
    let(:board) { instance_double(Board) }
    let(:next_moves) { [[2, 0], [3, 0], [2, 1]] }

    context 'when one move in check' do
      before do
        allow(piece).to receive(:next_moves).with(board).and_return(next_moves)
        allow(piece).to receive(:move_into_check?).and_return(false, false, true)
      end

      it 'returns valid next moves without move in check' do
        result = piece.valid_moves(board)
        expect(result).not_to include([2, 1])
      end
    end

    context 'when all moves in check' do
      before do
        allow(piece).to receive(:next_moves).with(board).and_return(next_moves)
        allow(piece).to receive(:move_into_check?).and_return(true, true, true)
      end

      it 'returns empty array of valid next moves' do
        result = piece.valid_moves(board)
        expect(result).to be_empty
      end
    end

    context 'when no moves in check' do
      before do
        allow(piece).to receive(:next_moves).with(board).and_return(next_moves)
        allow(piece).to receive(:move_into_check?).and_return(false, false, false)
      end

      it 'returns all moves as valid next moves' do
        result = piece.valid_moves(board)
        expect(result).to eq(next_moves)
      end
    end
  end

  describe '#move_into_check?' do
    subject(:move_into_check?) { piece.move_into_check?(board, [2, 0]) }
    let(:board) { instance_double(Board) }

    before do
      allow(Marshal).to receive(:dump).with(board)
      allow(Marshal).to receive(:load).and_return(board)
      allow(board).to receive(:move_piece!)
      allow(board).to receive(:check?)
    end

    it 'calls Marshal.dump once' do
      expect(Marshal).to receive(:dump).with(board).once
      move_into_check?
    end

    it 'calls Marshal.load once' do
      expect(Marshal).to receive(:load).once
      move_into_check?
    end

    it 'calls Board#move_piece! once' do
      expect(board).to receive(:move_piece!).once
      move_into_check?
    end

    context 'when in check after move' do
      before do
        allow(board).to receive(:check?).and_return(true)
      end

      it 'returns true' do
        expect(move_into_check?).to be_truthy
      end
    end

    context 'when not in check after move' do
      before do
        allow(board).to receive(:check?).and_return(false)
      end

      it 'returns false' do
        expect(move_into_check?).to be_falsey
      end
    end
  end
end
