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
                   :bust
                 )

      def make_decision(_)
        :hit
      end
    end
  end
end
