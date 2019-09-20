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

      option :player_count,
             Types::Integer.constrained(gteq: 1), default: -> { 4 }
      option :deck, Deck, default: -> { Deck.create }
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
        when :dealer_betting
          handle_dealer_decision!(dealer.make_decision)
        end
      end

      def finished?
        state == :finished
      end

      def result
        return unless finished?

        players.map do |player|
          case player_result(player)
          when :lost
            [:lost, player]
          when :won
            [:won, player, player.bet]
          when :tie
            [:tie, player]
          when :blackjack
            [:won, player, 1.5 * player.bet]
          when :surrendered
            [:surrendered, player]
          end
        end
      end

      def dealer_hand
        case state
        when :players_betting
          first, *rest = dealer.hand
          [
            first,
            *rest.map(&:hide)
          ]
        else
          dealer.hand
        end
      end

      def bank
        players.map(&:bet).sum
      end

      private

      def player_result(player)
        if player.surrendered?
          :surrendered
        elsif player.bust?
          :lost
        elsif dealer.bust?
          :won
        elsif dealer.blackjack? && !player.blackjack?
          :lost
        elsif dealer.blackjack? && player.blackjack?
          :tie
        elsif player.blackjack?
          :blackjack
        elsif player.sum > dealer.sum
          :won
        elsif player.sum < dealer.sum
          :lost
        else
          :tie
        end
      end

      def handle_dealer_decision!(decision)
        case decision
        when :hit
          @dealer = dealer.take_cards(select_cards!(1))

          finish! if dealer.bust?
        when :stand
          @dealer = dealer.stand
          finish!
        end
      end

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
        !everyone_failed? && players.none? { |player| player.state == :playing }
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
        Array.new(player_count) do |index|
          Player.new(
            hand: [],
            name: "Player #{index + 1}"
          )
        end.shuffle
      end

      def distribute_deck!
        return unless state == :players_betting

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
