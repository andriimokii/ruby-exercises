# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/pieces/rook'

RSpec.describe Board do
  subject(:board) { described_class.new([player, player]) }
  let(:player) { instance_double(Player) }

  describe '.on_board?' do
    context 'when position on board' do
      let(:position) { [0, 0] }

      it 'returns true' do
        result = described_class.on_board?(position)
        expect(result).to be(true)
      end
    end

    context 'when position not on board' do
      let(:position) { [-1, 0] }

      it 'returns false' do
        result = described_class.on_board?(position)
        expect(result).to be(false)
      end
    end
  end

  describe '.to_coords' do
    let(:notation) { 'a8' }
    let(:expectation) { [0, 0] }

    it 'returns board element indexes' do
      result = described_class.to_coords(notation)
      expect(result).to eq(expectation)
    end
  end

  describe '#square_checked?' do
    let(:position) { [0, 0] }

    context 'when board square checked' do
      before do
        board.board[position.first][position.last][:checked] = true
      end

      it 'returns true' do
        result = board.square_checked?(position)
        expect(result).to be(true)
      end
    end

    context 'when board square not checked' do
      before do
        board.board[position.first][position.last][:checked] = false
      end

      it 'returns true' do
        result = board.square_checked?(position)
        expect(result).to be(false)
      end
    end
  end

  describe '#move_verified?' do
    let(:position) { [0, 0] }

    context 'when #player_color? false' do
      before do
        allow(board).to receive(:player_color?).and_return(false)
      end

      it 'returns false' do
        result = board.move_verified?(player, *position)
        expect(result).to be(false)
      end
    end

    context 'when #player_color? true' do
      context 'when #move_in_list?, castle_verified?, en_passant_verified? false' do
        before do
          allow(board).to receive(:player_color?).and_return(true)
          allow(board).to receive(:move_in_list?).and_return(false)
          allow(board).to receive(:castle_verified?).and_return(false)
          allow(board).to receive(:en_passant_verified?).and_return(false)
        end

        it 'returns false' do
          result = board.move_verified?(player, *position)
          expect(result).to be(false)
        end
      end

      context 'when either #move_in_list?, castle_verified?, en_passant_verified? true' do
        before do
          allow(board).to receive(:player_color?).and_return(true)
          allow(board).to receive(:move_in_list?).and_return(true)
          allow(board).to receive(:castle_verified?).and_return(false)
          allow(board).to receive(:en_passant_verified?).and_return(false)
        end

        it 'returns true' do
          result = board.move_verified?(player, *position)
          expect(result).to be(true)
        end
      end
    end
  end

  describe '#check?' do
    let(:king_pos) { [0, 0] }
    let(:color) { :black }
    let(:enemy_color) { :white }

    context 'when king in check' do
      let(:enemy_checking_rook) { instance_double(Rook, next_moves: [[1, 0], [0, 0]]) }

      before do
        allow(board).to receive(:king_pos).with(color).and_return(king_pos)
        allow(board).to receive(:find_pieces).with(enemy_color).and_return([enemy_checking_rook])
      end

      it 'returns true' do
        result = board.check?(color)
        expect(result).to be(true)
      end
    end

    context 'when king not in check' do
      let(:enemy_basic_rook) { instance_double(Rook, next_moves: [[1, 1], [0, 1]]) }

      before do
        allow(board).to receive(:king_pos).with(color).and_return(king_pos)
        allow(board).to receive(:find_pieces).with(enemy_color).and_return([enemy_basic_rook])
      end

      it 'returns false' do
        result = board.check?(color)
        expect(result).to be(false)
      end
    end
  end

  describe '#checkmate?' do
    let(:color) { :black }
    let(:rook) { instance_double(Rook) }

    before do
      allow(board).to receive(:find_pieces).with(color).and_return([rook])
    end

    context 'when #check? false' do
      before do
        allow(board).to receive(:check?).with(color).and_return(false)
      end

      it 'returns false' do
        result = board.checkmate?(color)
        expect(result).to be(false)
      end
    end

    context 'when #check? true' do
      before do
        allow(board).to receive(:check?).with(color).and_return(true)
      end

      context '#valid_moves_none? false' do
        before do
          allow(board).to receive(:valid_moves_none?).with([rook]).and_return(false)
        end

        it 'returns false' do
          result = board.checkmate?(color)
          expect(result).to be(false)
        end
      end

      context '#valid_moves_none? true' do
        before do
          allow(board).to receive(:valid_moves_none?).with([rook]).and_return(true)
        end

        it 'returns true' do
          result = board.checkmate?(color)
          expect(result).to be(true)
        end
      end
    end
  end

  describe '#stalemate?' do
    let(:color) { :black }
    let(:rook) { instance_double(Rook) }

    before do
      allow(board).to receive(:find_pieces).with(color).and_return([rook])
    end

    context 'when #check? true' do
      before do
        allow(board).to receive(:check?).with(color).and_return(true)
      end

      it 'returns false' do
        result = board.stalemate?(color)
        expect(result).to be(false)
      end
    end

    context 'when #check? false' do
      before do
        allow(board).to receive(:check?).with(color).and_return(false)
      end

      context '#valid_moves_none? false' do
        before do
          allow(board).to receive(:valid_moves_none?).with([rook]).and_return(false)
        end

        it 'returns false' do
          result = board.stalemate?(color)
          expect(result).to be(false)
        end
      end

      context '#valid_moves_none? true' do
        before do
          allow(board).to receive(:valid_moves_none?).with([rook]).and_return(true)
        end

        it 'returns true' do
          result = board.stalemate?(color)
          expect(result).to be(true)
        end
      end
    end
  end

  describe '#make_turn' do
    let(:position) { [[0, 0], [0, 1]] }

    context 'when #castle_verified? true' do
      before do
        allow(board).to receive(:castle_verified?).and_return(true)
      end

      it 'calls #castle once' do
        expect(board).to receive(:castle).once
        board.make_turn(*position)
      end
    end

    context 'when #castle_verified? false' do
      before do
        allow(board).to receive(:castle_verified?).and_return(false)
      end

      context 'when #en_passant_verified? true' do
        before do
          allow(board).to receive(:en_passant_verified?).and_return(true)
          allow(board).to receive(:en_passant)
        end

        it 'calls #castle zero times' do
          expect(board).to receive(:castle).exactly(0).times
          board.make_turn(*position)
        end
      end

      context 'when #en_passant_verified? false' do
        before do
          allow(board).to receive(:en_passant_verified?).and_return(false)
        end

        context 'when #promote_verified? true' do
          before do
            allow(board).to receive(:promote_verified?).and_return(true)
            allow(board).to receive(:promote)
          end

          it 'calls #castle zero times' do
            expect(board).to receive(:castle).exactly(0).times
            board.make_turn(*position)
          end

          it 'calls #en_passant zero times' do
            expect(board).to receive(:en_passant).exactly(0).times
            board.make_turn(*position)
          end

          it 'calls #promote once' do
            expect(board).to receive(:promote).once
            board.make_turn(*position)
          end
        end

        context 'when #promote_verified? false' do
          before do
            allow(board).to receive(:promote_verified?).and_return(false)
            allow(board).to receive(:move_piece!)
            allow(board).to receive(:change_previous_piece!)
          end

          it 'calls #move_piece! once' do
            expect(board).to receive(:move_piece!).once
            board.make_turn(*position)
          end

          it 'calls #change_previous_piece! once' do
            expect(board).to receive(:change_previous_piece!).once
            board.make_turn(*position)
          end
        end
      end
    end
  end

  describe '#same_color?' do
    let(:position) { [0, 0] }
    let(:rook) { instance_double(Rook, color: :black) }

    before do
      allow(board).to receive(:piece_at).and_return(rook)
    end

    context 'when different colors' do
      let(:obj) { instance_double(Rook, color: :white) }

      it 'returns false' do
        result = board.same_color?(position, obj)
        expect(result).to be(false)
      end
    end

    context 'when same colors' do
      let(:obj) { instance_double(Rook, color: :black) }

      it 'returns true' do
        result = board.same_color?(position, obj)
        expect(result).to be(true)
      end
    end
  end
end
