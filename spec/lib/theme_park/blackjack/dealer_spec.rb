# frozen_string_literal: true

require 'theme_park/deck'
require 'theme_park/blackjack/dealer'

RSpec.describe ThemePark::Blackjack::Dealer do
  subject(:dealer) do
    described_class.new(hand: hand)
  end

  let(:deck) { ThemePark::Deck.create }
  let(:hand) { deck.shift(2) }

  describe '#make_decision' do
    subject(:make_decision) { dealer.make_decision(dealer.hand) }

    specify do
      expect(make_decision).to be(:hit)
    end
  end
end
