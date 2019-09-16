# frozen_string_literal: true

require 'theme_park/blackjack/game'

RSpec.describe ThemePark::Blackjack::Game do
  subject(:game) do
    described_class.new(player_count: player_count)
  end

  let(:player_count) { 5 }

  describe 'initializing a game' do
    it 'generates N players + dealer from player count' do
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

    let(:game) { described_class.new(player_count: player_count) }

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
        ThemePark::Blackjack::Player.new(
          hand: [],
          decision_handler: decision_handler
        )
      end

      let(:players) { [player] }

      describe ':hit' do
        let(:decision_handler) do
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
            }.from(:playing).to(:bust).and change(
              game, :state
            ).from(:players_betting).to(:finished)
          end
        end
      end

      describe '#surrender' do
        let(:decision_handler) do
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
      end

      describe '#stand' do
        let(:decision_handler) do
          lambda { |_player_hand, _dealer_hand|
            :stand
          }
        end

        it 'does not change deck size' do
          expect { proceed }.not_to change { game.deck.size }
        end

        it 'moves the game to dealer when there is only one player' do
          expect do
            proceed
          end.to change(game, :state).from(:players_betting).to(:dealer_betting)
        end
      end
    end

    describe 'dealer actions' do
      before do
        game.players.each do |player|
          allow(player).to receive(:make_decision).and_return(:stand)
        end

        game.proceed
      end

      context 'busting' do
        before do
          allow(game.dealer).to receive(:make_decision).and_return(:hit)
        end

        specify do
          expect do
            proceed
          end.to change(
            game, :state
          ).from(:dealer_betting).to(:finished).and change {
            game.dealer.state
          }.from(:playing).to(:bust)
        end
      end

      context 'hitting' do
        before do
          allow(game.dealer).to receive(:make_decision).and_return(:hit)
        end

        specify do
          expect do
            proceed
          end.not_to change(
            game, :state
          ).from(:dealer_betting)
        end
      end

      context 'standing' do
        before do
          allow(game.dealer).to receive(:make_decision).and_return(:stand)
        end

        specify do
          expect do
            proceed
          end.to change(
            game, :state
          ).from(:dealer_betting).to(:finished).and change {
            game.dealer.state
          }.from(:playing).to(:standing)
        end
      end
    end
  end
end
