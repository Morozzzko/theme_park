# frozen_string_literal: true

require 'theme_park/blackjack/game'

RSpec.describe ThemePark::Blackjack::Game do
  subject(:game) do
    described_class.new(ai_player_count: ai_player_count)
  end

  let(:ai_player_count) { 5 }
  let(:player_count) { ai_player_count + 1 }

  describe 'initializing a game' do
    it 'generates N AI players + user + dealer from AI player count' do
      expect(game.players.count).to eql(player_count)
    end

    it 'generates a dealer with two cards' do
      expect(game.dealer.hand.size).to be(2)
    end

    it 'distributes two cards across all players' do
      expect(
        game.players.map(&:hand).map(&:count).sum
      ).to eql(player_count * 2)
      expect(game.deck.size).to eql(52 - player_count * 2 - 2)
    end
  end

  describe '#proceed' do
    subject(:proceed) do
      game.proceed
    end

    let(:game) { described_class.new(ai_player_count: ai_player_count) }

    it 'increases turn count by 1' do
      expect { proceed }.to change(game, :turn_count).from(0).to(1)
    end
  end
end
