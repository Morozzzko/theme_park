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
    subject(:make_decision) { dealer.make_decision }

    context 'total less than 17' do
      let(:hand) do
        ThemePark::Deck[
          [
            ThemePark::Jack[suit: 'spades'],
            ThemePark::Number[rank: 6, suit: 'spades']
          ]
        ]
      end

      specify do
        expect(make_decision).to be(:hit)
      end
    end

    context 'total over than 17' do
      let(:hand) do
        ThemePark::Deck[
          [
            ThemePark::Jack[suit: 'spades'],
            ThemePark::Number[rank: 8, suit: 'spades']
          ]
        ]
      end

      specify do
        expect(make_decision).to be(:stand)
      end
    end

    context 'total exactly 17' do
      let(:hand) do
        ThemePark::Deck[
          [
            ThemePark::Jack[suit: 'spades'],
            ThemePark::Number[rank: 7, suit: 'spades']
          ]
        ]
      end

      specify do
        expect(make_decision).to be(:stand)
      end
    end
  end
end
