# frozen_string_literal: true

require 'theme_park/blackjack/game'

RSpec.describe ThemePark::Blackjack::Game do
  subject(:game) do
    described_class.new(ai_player_count: ai_player_count)
  end

  let(:ai_player_count) { 5 }
  let(:player_count) { ai_player_count + 2 }

  describe 'initializing a game' do
    it 'generates N AI players + user + dealer from AI player count' do
      expect(game.players.count).to eql(player_count)
    end

    it 'makes dealer the first player' do
      expect(game.players.first).to be_a(
        ThemePark::Blackjack::Players::Dealer
      )
    end

    it 'distributes two cards across all players' do
      expect(
        game.players.map(&:hand).map(&:count).sum
      ).to eql(player_count * 2)
      expect(game.deck.size).to eql(52 - player_count * 2)
    end
  end
end
