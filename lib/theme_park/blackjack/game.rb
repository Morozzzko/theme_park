# frozen_string_literal: true

require 'types'
require 'dry-initializer'
require 'theme_park/blackjack/players'
require 'theme_park/deck'

module ThemePark
  module Blackjack
    class Game
      extend Dry::Initializer

      option :ai_player_count, Types::Integer.constrained(included_in: 4..6)
      option :deck, Deck, default: -> { Deck.create }
      option :players, default: -> { generate_players! }
      option :dealer, default: -> { generate_dealer! }
      option :state,
             Types::Symbol.enum(:players_betting, :dealer_betting, :finished),
             default: -> { :players_betting }

      option :turn_count, Types::Integer, default: -> { 0 }

      def proceed
        @players = players.map do |player|
          handle_decision!(player.make_decision(dealer.hand))
        end

        turn_finished!
      end

      private

      def handle_decision!(decision)
        case decision
        in :hit
          {}
        in :stand
          {}
        in :double_down
          {}
        in :split
          {}
        in :surrender
          {}
        end
      end

      def turn_finished!
        @turn_count += 1
      end

      def generate_dealer!
        @dealer = Players::Dealer.new(hand: select_cards!(2))
      end

      def generate_players!
        user = Players::User.new(hand: select_cards!(2))
        ai_players = Array.new(ai_player_count) do
          Players::AI.new(hand: select_cards!(2))
        end

        [user, *ai_players].shuffle
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
