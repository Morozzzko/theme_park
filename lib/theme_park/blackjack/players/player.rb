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

        def make_decision(dealer_hand)
          if attributes.include?(:decision_handler)
            decision_handler.call(hand, dealer_hand)
          else
            :surrender
          end
        end
      end
    end
  end
end
