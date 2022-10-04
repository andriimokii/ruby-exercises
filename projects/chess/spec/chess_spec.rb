# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/chess'
require_relative '../lib/player'
require_relative '../lib/board'

RSpec.describe Chess do
  subject(:chess) { described_class.new([player, player], board) }
  let(:player) { instance_double(Player) }
  let(:board) { instance_double(Board) }

  describe '#start' do
    before do
      allow(chess).to receive(:puts)
      allow(chess).to receive(:configure_board!).and_return(nil)
      allow(board).to receive(:display_board).and_return(nil)
    end

    context 'when #game_over? is true' do
      before do
        allow(chess).to receive(:game_over?).and_return(true)
      end

      it 'calls #turn_order zero time' do
        expect(chess).to receive(:turn_order).exactly(0).times
        chess.start
      end
    end

    context 'when #game_over? is false, false, than true' do
      before do
        allow(chess).to receive(:game_over?).and_return(false, false, true)
        allow(chess).to receive(:turn_order)
      end

      it 'calls #turn_order twice' do
        expect(chess).to receive(:turn_order).twice
        chess.start
      end
    end
  end

  describe '#configure_board!' do
    context 'when #load_game? is false' do
      before do
        allow(chess).to receive(:load_game?).and_return(false)
      end

      it 'calls Board#place_pieces once' do
        expect(board).to receive(:place_pieces).once
        chess.configure_board!
      end
    end

    context 'when #load_game? is true' do
      let(:deserialized_chess) do
        instance_double(Chess, board: deserialized_board, players: [deserialized_player, deserialized_player])
      end

      let(:deserialized_player) { instance_double(Player) }
      let(:deserialized_board) { instance_double(Board) }

      before do
        allow(chess).to receive(:load_game?).and_return(true)
        allow(chess).to receive(:load_game).and_return(deserialized_chess)
      end

      it 'changes @board variable' do
        expect { chess.configure_board! }.to change { chess.board }.to(deserialized_board)
      end

      it 'changes @players variable' do
        expect { chess.configure_board! }.to change { chess.players }.to([deserialized_player, deserialized_player])
      end
    end
  end

  describe '#game_over?' do
    before do
      allow(player).to receive(:color)
    end

    context 'when Board#checkmate? true' do
      before do
        allow(board).to receive(:checkmate?).and_return(true)
      end

      it 'returns true' do
        result = chess.game_over?
        expect(result).to be(true)
      end
    end

    context 'when Board#checkmate? false, and Board#stalemate? true' do
      before do
        allow(board).to receive(:checkmate?).and_return(false)
        allow(board).to receive(:stalemate?).and_return(true)
      end

      it 'returns true' do
        result = chess.game_over?
        expect(result).to be(true)
      end
    end

    context 'when Board#checkmate? false, and Board#stalemate? false' do
      before do
        allow(board).to receive(:checkmate?).and_return(false)
        allow(board).to receive(:stalemate?).and_return(false)
      end

      it 'returns false' do
        result = chess.game_over?
        expect(result).to be(false)
      end
    end
  end

  describe '#player_turn' do
    let(:player_input) { [[0, 0], [1, 0]] }

    context 'when #verify_input is false once' do
      before do
        allow(chess).to receive(:player_input)
        allow(chess).to receive(:verify_input).and_return(nil, player_input)
      end

      it 'prints error message once' do
        expect(chess).to receive(:puts).with('Input error!').once
        chess.player_turn
      end
    end

    context 'when #verify_input is true' do
      before do
        allow(chess).to receive(:player_input)
        allow(chess).to receive(:verify_input).and_return(player_input)
      end

      it 'returns verified input' do
        result = chess.player_turn
        expect(result).to eq(player_input)
      end

      it 'prints error message zero times' do
        expect(chess).to receive(:puts).with('Input error!').exactly(0).times
        chess.player_turn
      end
    end
  end

  describe '#verify_input' do
    let(:input) { [[0, 0], [1, 0]] }

    context 'when input not nil, #input_on_board? true, Board#move_verified? true' do
      before do
        allow(chess).to receive(:input_on_board?).and_return(true)
        allow(board).to receive(:move_verified?).and_return(true)
      end

      it 'returns input' do
        result = chess.verify_input(input)
        expect(result).to eq(input)
      end
    end

    context 'when input nil' do
      let(:input) { nil }

      before do
        allow(chess).to receive(:input_on_board?).and_return(true)
        allow(board).to receive(:move_verified?).and_return(true)
      end

      it 'returns nil' do
        result = chess.verify_input(input)
        expect(result).to be_nil
      end
    end

    context 'when #input_on_board? false' do
      before do
        allow(chess).to receive(:input_on_board?).and_return(false)
        allow(board).to receive(:move_verified?).and_return(true)
      end

      it 'returns nil' do
        result = chess.verify_input(input)
        expect(result).to be_nil
      end
    end

    context 'when Board#move_verified? false' do
      before do
        allow(chess).to receive(:input_on_board?).and_return(true)
        allow(board).to receive(:move_verified?).and_return(false)
      end

      it 'returns nil' do
        result = chess.verify_input(input)
        expect(result).to be_nil
      end
    end
  end

  describe '#input_on_board?' do
    context 'when all coordinates of input are on board' do
      let(:input) { [[0, 0], [1, 0]] }

      before do
        allow(Board).to receive(:on_board?).and_return(true, true)
      end

      it 'returns true' do
        result = chess.input_on_board?(input)
        expect(result).to be(true)
      end
    end

    context 'when one coordinate is out of board' do
      let(:input) { [[0, 0], [-1, 0]] }

      before do
        allow(Board).to receive(:on_board?).and_return(true, false)
      end

      it 'returns false' do
        result = chess.input_on_board?(input)
        expect(result).to be(false)
      end
    end
  end

  describe '#rotate_players!' do
    it 'calls Array#rotate!' do
      expect(chess.players).to receive(:rotate!).once
      chess.rotate_players!
    end
  end

  describe '#player_input' do
    before do
      allow(player).to receive(:color).and_return(:black)
      allow(chess).to receive(:gets).and_return(input)
    end

    context 'when input is q' do
      let(:input) { 'q' }

      it 'calls Kernel#exit once' do
        expect(chess).to receive(:exit).once
        chess.player_input
      end
    end

    context 'when input is s' do
      let(:input) { 's' }

      before do
        allow(chess).to receive(:save_game).and_return(nil)
      end

      it 'calls #save_game once' do
        expect(chess).to receive(:save_game).once
        chess.player_input
      end

      it 'returns nil' do
        result = chess.player_input
        expect(result).to be_nil
      end
    end

    context 'when one input value' do
      let(:input) { 'a7' }

      it 'returns nil' do
        result = chess.player_input
        expect(result).to be_nil
      end
    end

    context 'when input empty' do
      let(:input) { '' }

      it 'returns nil' do
        result = chess.player_input
        expect(result).to be_nil
      end
    end
  end
end
