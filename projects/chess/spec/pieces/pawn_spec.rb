# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'
require_relative '../../lib/board'

RSpec.describe Pawn do
  subject(:pawn) { described_class.new([1, 0], :black, 'P') }

  describe '.to_unicode_symbol' do
    context 'when color white' do
      let(:color) { :white }
      let(:white_pawn_symbol) { "\u2659" }

      it 'returns white pawn symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(white_pawn_symbol)
      end
    end

    context 'when color black' do
      let(:color) { :black }
      let(:black_pawn_symbol) { "\u265F" }

      it 'returns black pawn symbol' do
        result = described_class.to_unicode_symbol(color)
        expect(result).to eq(black_pawn_symbol)
      end
    end
  end

  describe '.straight_offsets' do
    context 'when color white' do
      let(:color) { :white }
      let(:white_straight_offsets) { [[-1, 0], [-2, 0]] }

      it 'returns offsets for straight moves' do
        result = described_class.straight_offsets(color)
        expect(result).to eq(white_straight_offsets)
      end
    end

    context 'when color black' do
      let(:color) { :black }
      let(:black_straight_offsets) { [[1, 0], [2, 0]] }

      it 'returns offsets for straight moves' do
        result = described_class.straight_offsets(color)
        expect(result).to eq(black_straight_offsets)
      end
    end
  end

  describe '.attack_offsets' do
    context 'when color white' do
      let(:color) { :white }
      let(:white_attack_offsets) { [[-1, -1], [-1, 1]] }

      it 'returns offsets for attack moves' do
        result = described_class.attack_offsets(color)
        expect(result).to eq(white_attack_offsets)
      end
    end

    context 'when color black' do
      let(:color) { :black }
      let(:black_attack_offsets) { [[1, -1], [1, 1]] }

      it 'returns offsets for attack moves' do
        result = described_class.attack_offsets(color)
        expect(result).to eq(black_attack_offsets)
      end
    end
  end

  describe '#position=' do
    let(:new_position) { [2, 0] }

    it 'changes @has_moved to true' do
      expect { pawn.position = new_position }.to change { pawn.has_moved }.from(false).to(true)
    end

    context 'when #en_passant? is true' do
      before do
        allow(pawn).to receive(:en_passant?).and_return(true)
      end

      it 'changes @en_passant to true' do
        expect { pawn.position = new_position }.to change { pawn.en_passant }.from(false).to(true)
      end
    end

    context 'when #en_passant? is false' do
      before do
        allow(pawn).to receive(:en_passant?).and_return(true, false)
        pawn.position = new_position
      end

      it 'changes @en_passant from true to false' do
        expect { pawn.position = new_position }.to change { pawn.en_passant }.from(true).to(false)
      end
    end
  end

  describe '#next_moves' do
    let(:board) { instance_double(Board) }
    let(:next_straight_moves) { [[2, 0], [3, 0]] }
    let(:next_attack_moves) { [[2, 1]] }

    before do
      allow(pawn).to receive(:next_straight_moves).and_return(next_straight_moves)
      allow(pawn).to receive(:next_attack_moves).and_return(next_attack_moves)
    end

    it 'returns next straight and attack moves' do
      result = pawn.next_moves(board)
      expect(result).to eq(next_straight_moves + next_attack_moves)
    end
  end

  describe '#next_straight_moves' do
    let(:board) { instance_double(Board) }
    let(:straight_offsets) { [[1, 0], [2, 0]] }

    before do
      allow(described_class).to receive(:straight_offsets).and_return(straight_offsets)
    end

    context 'when #straight_move_verified? true for all moves' do
      before do
        allow(pawn).to receive(:straight_move_verified?).and_return(true, true)
      end

      it 'returns all moves' do
        result = pawn.next_straight_moves(board)
        expect(result.size).to eq(straight_offsets.size)
      end
    end

    context 'when #straight_move_verified? true, than false' do
      before do
        allow(pawn).to receive(:straight_move_verified?).and_return(true, false)
      end

      it 'returns one move' do
        result = pawn.next_straight_moves(board)
        expect(result.size).to eq(1)
      end
    end

    context 'when #straight_move_verified? false for all moves' do
      before do
        allow(pawn).to receive(:straight_move_verified?).and_return(false, false)
      end

      it 'returns zero moves' do
        result = pawn.next_straight_moves(board)
        expect(result.size).to be_zero
      end
    end
  end

  describe '#next_attack_moves' do
    let(:board) { instance_double(Board) }
    let(:attack_offsets) { [[1, -1], [1, 1]] }

    before do
      allow(described_class).to receive(:attack_offsets).and_return(attack_offsets)
    end

    context 'when #attack_move_verified? true for all moves' do
      before do
        allow(pawn).to receive(:attack_move_verified?).and_return(true, true)
      end

      it 'returns all moves' do
        result = pawn.next_attack_moves(board)
        expect(result.size).to eq(attack_offsets.size)
      end
    end

    context 'when #straight_move_verified? true, than false' do
      before do
        allow(pawn).to receive(:attack_move_verified?).and_return(true, false)
      end

      it 'returns one move' do
        result = pawn.next_attack_moves(board)
        expect(result.size).to eq(1)
      end
    end

    context 'when #attack_move_verified? false for all moves' do
      before do
        allow(pawn).to receive(:attack_move_verified?).and_return(false, false)
      end

      it 'returns zero moves' do
        result = pawn.next_attack_moves(board)
        expect(result.size).to be_zero
      end
    end
  end
end
