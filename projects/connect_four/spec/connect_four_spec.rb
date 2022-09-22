# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/connect_four'
require_relative '../lib/player'

RSpec.describe ConnectFour do
  subject(:game) { described_class.new }

  describe '#start' do
    context 'when #game_over? is false once' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:shuffle_players!)
        allow(game).to receive(:game_over?).and_return(false, true)
      end

      it 'calls #turn_order once' do
        expect(game).to receive(:turn_order).once
        game.start
      end
    end

    context 'when #game_over? is false twice' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:shuffle_players!)
        allow(game).to receive(:game_over?).and_return(false, false, true)
      end

      it 'calls #turn_order twice' do
        expect(game).to receive(:turn_order).twice
        game.start
      end
    end
  end

  describe '#shuffle_players!' do
    let(:player) { instance_double(Player) }
    subject(:game) { described_class.new([player, player]) }

    it 'calls Array#shuffle! once' do
      expect(game.players).to receive(:shuffle!).once
      game.shuffle_players!
    end
  end

  describe '#rotate_players' do
    let(:player) { instance_double(Player) }
    subject(:game) { described_class.new([player, player]) }

    it 'calls Array#rotate! once' do
      expect(game.players).to receive(:rotate!).once
      game.rotate_players!
    end
  end

  describe '#update_board' do
    let(:player) { instance_double(Player) }
    subject(:game) { described_class.new([player]) }

    context 'when #heap_peak? is true' do
      before do
        allow(game).to receive(:heap_peak?).and_return(true)
      end

      it 'returns nil' do
        player_turn = 0
        result = game.update_board(player_turn)
        expect(result).to be_nil
      end
    end

    context 'when #heap_peak? is false' do
      let(:player_turn) { 0 }
      let(:board_index) { 35 }

      before do
        allow(game).to receive(:heap_peak?).and_return(false)
        allow(game).to receive(:get_board_index).with(player_turn).and_return(board_index)
      end

      it 'updates the board with player turn' do
        expect { game.update_board(player_turn) }.to change {
          game.board[board_index]
        }.from({ checked: false,
                 player: nil }).to({ checked: true,
                                     player: game.players.first })
      end
    end
  end

  describe '#heap_peak?' do
    context 'when column of board is full' do
      let(:player) { instance_double(Player) }
      subject(:game) { described_class.new([player]) }

      before do
        column_indexes = [0, 7, 14, 21, 28, 35]
        game.board =
          Array.new(game.board.size) do |index|
            if column_indexes.include?(index)
              { checked: true, player: }
            else
              { checked: false, player: nil }
            end
          end
      end

      it 'returns true' do
        player_turn = 0
        result = game.heap_peak?(player_turn)
        expect(result).to be(true)
      end
    end

    context 'when column of board is not full' do
      let(:player) { instance_double(Player) }
      subject(:game) { described_class.new([player]) }

      before do
        column_indexes = [7, 14, 21, 28, 35]
        game.board =
          Array.new(game.board.size) do |index|
            if column_indexes.include?(index)
              { checked: true, player: }
            else
              { checked: false, player: nil }
            end
          end
      end

      it 'returns false' do
        player_turn = 0
        result = game.heap_peak?(player_turn)
        expect(result).to be(false)
      end
    end
  end

  describe '#get_board_index' do
    context 'when #heap_peak? is true once' do
      let(:player_turn) { 0 }
      let(:items_per_row) { 7 }

      before do
        allow(game).to receive(:heap_peak?).with(player_turn + items_per_row).and_return(true)
        allow(game).to receive(:board_cell_nil?).and_return(false)
      end

      it 'returns board index supplied by user unchanged' do
        result = game.get_board_index(player_turn, items_per_row)
        expect(result).to eq(player_turn)
      end
    end

    context 'when #board_cell_nil? is true once' do
      let(:player_turn) { 0 }
      let(:items_per_row) { 7 }

      before do
        allow(game).to receive(:heap_peak?).with(player_turn + items_per_row).and_return(false)
        allow(game).to receive(:board_cell_nil?).and_return(true)
      end

      it 'returns board index supplied by user unchanged' do
        result = game.get_board_index(player_turn, items_per_row)
        expect(result).to eq(player_turn)
      end
    end

    context 'when #heap_peak? is false, then true' do
      let(:player_turn) { 0 }
      let(:items_per_row) { 7 }

      before do
        allow(game).to receive(:heap_peak?).and_return(false, true)
        allow(game).to receive(:board_cell_nil?).and_return(false, false)
      end

      it 'returns board index supplied by user incremented by cells count per row' do
        result = game.get_board_index(player_turn, items_per_row)
        expect(result).to eq(player_turn + items_per_row)
      end
    end

    context 'when #board_cell_nil? is false, then true' do
      let(:player_turn) { 0 }
      let(:items_per_row) { 7 }

      before do
        allow(game).to receive(:heap_peak?).and_return(false, false)
        allow(game).to receive(:board_cell_nil?).and_return(false, true)
      end

      it 'returns board index supplied by user incremented by cells count per row' do
        result = game.get_board_index(player_turn, items_per_row)
        expect(result).to eq(player_turn + items_per_row)
      end
    end

    context 'when #heap_peak? is false, false, then true' do
      let(:player_turn) { 0 }
      let(:items_per_row) { 7 }

      before do
        allow(game).to receive(:heap_peak?).and_return(false, false, true)
        allow(game).to receive(:board_cell_nil?).and_return(false, false, false)
      end

      it 'returns board index supplied by user incremented by 2 * cells count per row' do
        result = game.get_board_index(player_turn, items_per_row)
        expect(result).to eq(player_turn + 2 * items_per_row)
      end
    end

    context 'when #board_cell_nil? is false, false, then true' do
      let(:player_turn) { 0 }
      let(:items_per_row) { 7 }

      before do
        allow(game).to receive(:heap_peak?).and_return(false, false, false)
        allow(game).to receive(:board_cell_nil?).and_return(false, false, true)
      end

      it 'returns board index supplied by user incremented by cells count per row' do
        result = game.get_board_index(player_turn, items_per_row)
        expect(result).to eq(player_turn + 2 * items_per_row)
      end
    end
  end

  describe '#player_turn' do
    context 'when #verify_input is not nil' do
      before do
        allow(game).to receive(:verify_input).and_return('0')
      end

      it 'calls #verify_input once' do
        expect(game).to receive(:verify_input).once
        game.player_turn
      end
    end

    context 'when #verify_input is nil once' do
      before do
        allow(game).to receive(:verify_input).and_return(nil, '0')
      end

      it 'calls #verify_input twice' do
        expect(game).to receive(:verify_input).twice
        game.player_turn
      end

      it 'displays error message once' do
        error_message = 'Input error!'

        expect(game).to receive(:puts).with(error_message).once
        game.player_turn
      end
    end
  end

  describe '#verify_input' do
    context 'when given a valid input' do
      it 'returns valid input' do
        valid_input = '0'
        verified_input = game.verify_input(valid_input)

        expect(verified_input).to eq(valid_input)
      end
    end

    context 'when given invalid input' do
      it 'returns nil' do
        invalid_input = '99999'
        verified_input = game.verify_input(invalid_input)

        expect(verified_input).to be_nil
      end
    end
  end

  describe '#game_over?' do
    context 'when #game_status is neither win, nor draw' do
      before do
        allow(game).to receive(:display_status)
        allow(game).to receive(:game_status).and_return({ win: false, draw: false })
      end

      it 'calls #display_status once' do
        expect(game).to receive(:display_status).once
        game.game_over?
      end

      it 'returns false' do
        expect(game.game_over?).to be(false)
      end
    end

    context 'when #game_status is win, not draw' do
      before do
        allow(game).to receive(:display_status)
        allow(game).to receive(:game_status).and_return({ win: true, draw: false })
      end

      it 'calls #display_status once' do
        expect(game).to receive(:display_status).once
        game.game_over?
      end

      it 'returns true' do
        expect(game.game_over?).to be(true)
      end
    end

    context 'when #game_status is draw, not win' do
      before do
        allow(game).to receive(:display_status)
        allow(game).to receive(:game_status).and_return({ win: false, draw: true })
      end

      it 'calls #display_status once' do
        expect(game).to receive(:display_status).once
        game.game_over?
      end

      it 'returns true' do
        expect(game.game_over?).to be(true)
      end
    end
  end

  describe '#game_status' do
    context 'when there is four X (or O) in row' do
      let(:player) { instance_double(Player) }
      subject(:game) { described_class.new([player]) }

      before do
        4.times { |index| game.board[index] = { checked: true, player: } }
      end

      it 'returns win status true, and draw status false' do
        expect(game.game_status).to eq({ win: true, draw: false })
      end
    end

    context 'when there is four X (or O) in column' do
      let(:player) { instance_double(Player) }
      subject(:game) { described_class.new([player]) }

      before do
        column_cell_indexes = [0, 7, 14, 21]
        column_cell_indexes.each { |index| game.board[index] = { checked: true, player: } }
      end

      it 'returns win status true, and draw status false' do
        expect(game.game_status).to eq({ win: true, draw: false })
      end
    end

    context 'when there is four X (or O) in diagonal' do
      let(:player) { instance_double(Player) }
      subject(:game) { described_class.new([player]) }

      before do
        diagonal_cell_indexes = [0, 8, 16, 24]
        diagonal_cell_indexes.each { |index| game.board[index] = { checked: true, player: } }
      end

      it 'returns win status true, and draw status false' do
        expect(game.game_status).to eq({ win: true, draw: false })
      end
    end

    context 'when board full but no winner (no four X or O in row/column/diagonal)' do
      let(:player_1) { instance_double(Player) }
      let(:player_2) { instance_double(Player) }
      subject(:game) { described_class.new([player_1, player_2]) }

      before do
        first_player_turns = [0, 1, 5, 9, 10, 11, 13, 14, 15, 16, 18, 24, 26, 27, 29, 33, 36, 37, 38, 40, 41]
        game.board =
          Array.new(game.board.size) do |index|
            if first_player_turns.include?(index)
              { checked: true, player: player_1 }
            else
              { checked: true, player: player_2 }
            end
          end
      end

      it 'returns draw status true, and win status false' do
        expect(game.game_status).to eq({ win: false, draw: true })
      end
    end

    context 'when board not full, and no winner' do
      let(:player_1) { instance_double(Player) }
      let(:player_2) { instance_double(Player) }
      subject(:game) { described_class.new([player_1, player_2]) }

      before do
        game.board[0] = { checked: true, player: player_1 }
        game.board[1] = { checked: true, player: player_2 }
      end

      it 'returns draw status false, and win status false' do
        expect(game.game_status).to eq({ win: false, draw: false })
      end
    end

    context 'when board empty' do
      it 'returns draw status false, and win status false' do
        expect(game.game_status).to eq({ win: false, draw: false })
      end
    end
  end
end
