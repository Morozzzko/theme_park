# frozen_string_literal: true

require 'types'
require 'theme_park/card'

module ThemePark
  module Blackjack
    class Dealer < Dry::Struct
      attribute :hand, Types::Array.of(Card)
      attribute? :state,
                 Types::Symbol.default(:playing).enum(
                   :playing,
                   :standing,
                   :bust
                 )

      def initialize(*, **)
        super

        attributes[:state] = :bust if bust?
      end

      def make_decision
        if sum < 17
          :hit
        else
          :stand
        end
      end

      def blackjack?
        sum == 21 && hand.size == 2
      end

      def bust?
        state == :bust || sum > 21
      end

      def take_cards(cards)
        new(hand: hand + cards)
      end

      def sum
        hand.map(&:value).sum
      end

      def stand
        new(state: :standing)
      end
    end
  end
end
