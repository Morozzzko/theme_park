# frozen_string_literal: true

require 'types'
require 'dry-initializer'
require 'theme_park/blackjack/players'
require 'theme_park/deck'

module ThemePark
  module Blackjack
    class Game
      extend Dry::Initializer

      option :ai_player_count, Types::Integer.constrained(included_in: 4..6), default: -> { 4 }
      option :deck, Deck, default: -> { Deck.create }
      option :player, Players::Player, default: -> { Players::User.new(hand: []) }
      option :dealer, default: -> { generate_dealer! }
      option :players, default: -> { generate_players! }
      option :state,
             Types::Symbol.enum(:players_betting, :dealer_betting, :finished),
             default: -> { :players_betting }

      option :turn_count, Types::Integer, default: -> { 0 }

      def initialize(*)
        super

        distribute_deck!
      end

      def proceed
        case state
        in :players_betting
          @players = players.map do |player|
            handle_decision!(player, player.make_decision(dealer.hand))
          end
          turn_finished!
        in :dealer_betting
          # TODO: implement
          nil
        in :finished
          # nothing to do here
        end
      end

      private

      def handle_decision!(player, decision)
        # everything is no-op right now
        case decision
        in :hit
          player.new(hand: player.hand + select_cards!(1))
        in :stand
          player
        in :double_down
          player
        in :split
          player
        in :surrender
          player
        end
      end

      def turn_finished!
        @turn_count += 1
      end

      def generate_dealer!
        @dealer = Players::Dealer.new(hand: select_cards!(2))
      end

      def generate_players!
        user = player.new(hand: [])
        ai_players = Array.new(ai_player_count) do
          Players::AI.new(hand: [])
        end

        [user, *ai_players].shuffle
      end

      def distribute_deck!
        @players = players.map do |player|
          player.new(hand: select_cards!(2))
        end
      end

      def select_cards!(count)
        new_deck = deck[count..]

        selected = deck[0...count]

        @deck = new_deck

        selected
      end
    end
  end
end
