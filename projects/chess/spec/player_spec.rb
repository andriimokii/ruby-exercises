# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/player'

RSpec.describe Player do
  subject(:player) { described_class.new('Player #1', :white) }

  describe '#to_s' do
    let(:name) { 'Player #1' }

    it 'prints object as player name' do
      result = player.to_s
      expect(result).to eq(name)
    end
  end
end
