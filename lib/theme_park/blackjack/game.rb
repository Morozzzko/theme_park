# frozen_string_literal: true

require 'types'
require 'dry-initializer'
require 'theme_park/deck'
require 'theme_park/blackjack/player'
require 'theme_park/blackjack/dealer'

module ThemePark
  module Blackjack
    class Game
      extend Dry::Initializer

      option :ai_player_count, Types::Integer.constrained(included_in: 4..6), default: -> { 4 }
      option :deck, Deck, default: -> { Deck.create }
      option :player, Player, default: -> { Player.new(hand: []) }
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
        when :players_betting
          @players = players.map do |player|
            handle_decision!(player, player.make_decision(dealer.hand))
          end
          turn_finished!
        end
      end

      private

      def handle_decision!(player, decision)
        case decision
        when :hit
          player.take_cards(select_cards!(1))
        when :surrender
          player.surrender
        when :stand
          player.stand
        end
      end

      def turn_finished!
        @turn_count += 1

        if everyone_failed?
          finish!
        elsif everyone_waiting?
          play_dealer!
        end
      end

      def everyone_failed?
        # TODO: move logic somewhere else

        players.none? { |player| %i[playing standing].include?(player.state) }
      end

      def everyone_waiting?
        players.none? { |player| player.state == 'playing' } && !everyone_failed?
      end

      def play_dealer!
        @state = :dealer_betting
      end

      def finish!
        @state = :finished
      end

      def generate_dealer!
        @dealer = Dealer.new(hand: select_cards!(2))
      end

      def generate_players!
        user = player.new(hand: [])
        ai_players = Array.new(ai_player_count) do
          Player.new(hand: [])
        end

        [user, *ai_players].shuffle
      end

      def distribute_deck!
        @players = players.map do |player|
          player.take_cards(select_cards!(2))
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
