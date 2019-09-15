# frozen_string_literal: true

require 'types'
require 'theme_park/card'

module ThemePark
  module Blackjack
    module Players
      class Player < Dry::Struct
        attribute :hand, Types::Array.of(Card)
        attribute? :state,
                   Types::Symbol.default(:playing).enum(
                     :playing,
                     :standing,
                     :surrendered,
                     :bust
                   )
        attribute? :decision_handler,
                   Types::Any

        def initialize(*, **)
          super

          attributes[:state] = :bust if bust?
        end

        def make_decision(dealer_hand)
          if attributes.include?(:decision_handler)
            decision_handler.call(hand, dealer_hand)
          else
            :hit
          end
        end

        def sum
          hand.map(&:value).sum
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

        def surrender
          new(state: :surrendered)
        end

        def stand
          new(state: :standing)
        end
      end
    end
  end
end
