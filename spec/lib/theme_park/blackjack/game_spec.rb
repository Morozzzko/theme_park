# frozen_string_literal: true

require 'theme_park/blackjack/game'

RSpec.describe ThemePark::Blackjack::Game do
  subject(:game) do
    described_class.new(ai_player_count: ai_player_count)
  end

  let(:ai_player_count) { 5 }

  describe 'initializing a game' do
    let(:player_count) { ai_player_count + 1 }

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

    it 'starts in the :players_betting state' do
      expect(game.state).to be(:players_betting)
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

    it 'iteratres over each player and asks them to decide' do
      players = game.players

      players.each do |player|
        allow(player).to receive(:make_decision).and_return(:hit)
      end

      proceed

      expect(players).to all(
        have_received(:make_decision).with(game.dealer.hand)
      )
    end

    describe 'player decisions' do
      subject(:game) do
        described_class.new(player: player, players: players)
      end

      let(:player) do
        ThemePark::Blackjack::Players::User.new(
          hand: [],
          decision_handler: make_decision
        )
      end

      let(:players) { [player] }

      describe ':hit' do
        let(:make_decision) do
          lambda { |_player_hand, _dealer_hand|
            :hit
          }
        end

        it 'removes a card from the deck and adds it to the player hand' do
          expect do
            proceed
          end.to change {
            game.deck.size
          }.from(48).to(47).and change {
            game.players.first.hand.size
          }.from(2).to(3)
        end

        context 'the only player is about to bust' do
          subject(:game) do
            described_class.new(player: player, players: [player], deck: deck)
          end

          let(:deck) do
            ThemePark::Deck[
              [
                ThemePark::Jack[suit: 'spades'],
                ThemePark::Jack[suit: 'hearts'],
                ThemePark::Jack[suit: 'clubs'],
                ThemePark::Jack[suit: 'diamonds'],
                ThemePark::Queen[suit: 'spades'],
                ThemePark::Queen[suit: 'hearts'],
                ThemePark::Queen[suit: 'clubs'],
                ThemePark::Queen[suit: 'diamonds']
              ]
            ]
          end

          specify do
            expect do
              proceed
            end.to change {
              game.players.first.state
            }.from(:playing).to(:bust).and change(game, :state).from(:players_betting).to(:finished)
          end
        end
      end

      describe ':surrender' do
        let(:make_decision) do
          lambda { |_player_hand, _dealer_hand|
            :surrender
          }
        end

        it 'does not change deck size' do
          expect { proceed }.not_to change { game.deck.size }
        end

        it 'finishes game when there is only one player' do
          expect { proceed }.to change(game, :state).from(:players_betting).to(:finished)
        end

        context 'multiple players' do
          let(:players) do
            [
              player,
              ThemePark::Blackjack::Players::Player[hand: []]
            ]
          end

          specify do
            expect { proceed }.not_to change(game, :state).from(:players_betting)
          end
        end
      end
    end
  end
end
