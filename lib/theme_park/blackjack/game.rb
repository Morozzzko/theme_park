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
      option :players, default: -> { generate_players }

      private

      def generate_players
        dealer = Players::Dealer.new(hand: select_cards!(2))
        user = Players::User.new(hand: select_cards!(2))
        ai_players = Array.new(ai_player_count) do
          Players::AI.new(hand: select_cards!(2))
        end

        shuffled_players = [user, *ai_players].shuffle

        [dealer] + shuffled_players
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
