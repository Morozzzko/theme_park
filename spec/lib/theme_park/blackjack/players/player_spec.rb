# frozen_string_literal: true

require 'theme_park/deck'
require 'theme_park/blackjack/players/player'

RSpec.describe ThemePark::Blackjack::Players::Player do
  subject(:player) do
    described_class.new(hand: hand)
  end

  let(:hand) { [] }

  describe '#blackjack?' do
    subject(:blackjack?) { player.blackjack? }

    context 'real blackjack' do
      context 'ace first' do
        let(:hand) do
          ThemePark::Deck[
            [
              ThemePark::Ace[suit: 'spades'],
              ThemePark::Number[rank: 10, suit: 'spades']
            ]
          ]
        end

        specify do
          expect(blackjack?).to be(true)
        end
      end

      context 'ace second' do
        let(:hand) do
          ThemePark::Deck[
            [
              ThemePark::Number[rank: 10, suit: 'spades'],
              ThemePark::Ace[suit: 'spades']
            ]
          ]
        end

        specify do
          expect(blackjack?).to be(true)
        end
      end

      context 'empty hand' do
        specify do
          expect(blackjack?).to be false
        end
      end

      context '21, not blackjack' do
        let(:hand) do
          ThemePark::Deck[
            [
              ThemePark::Number[rank: 10, suit: 'spades'],
              ThemePark::Ace[suit: 'spades'],
              ThemePark::Number[rank: 10, suit: 'spades']
            ]
          ]
        end

        specify do
          expect(blackjack?).to be(false)
        end
      end
    end
  end

  describe '#sum' do
    subject(:sum) { player.sum }

    let(:hand) do
      ThemePark::Deck[
        [
          ThemePark::Jack[suit: 'spades'],
          ThemePark::Queen[suit: 'spades'],
          ThemePark::King[suit: 'spades']
        ]
      ]
    end

    it 'delegates to #value' do
      player.hand.each do |card|
        allow(card).to receive(:value).and_call_original
      end

      expect(sum).to be(30)

      expect(hand).to all(have_received(:value))
    end

    describe 'ace' do
      context 'blackjack' do
        let(:hand) do
          [
            ThemePark::Ace[suit: 'spades'],
            ThemePark::King[suit: 'spades']
          ]
        end

        specify do
          expect(sum).to be(21)
        end
      end
    end
  end

  describe '#surrender' do
    subject(:surrender) { player.surrender }

    specify do
      expect(surrender).to be_a(described_class)
      expect(surrender).not_to be(player)
      expect(surrender.state).to be(:surrendered)
    end
  end

  describe '#stand' do
    subject(:stand) { player.stand }

    specify do
      expect(stand).to be_a(described_class)
      expect(stand).not_to be(player)
      expect(stand.state).to be(:standing)
    end
  end
end
