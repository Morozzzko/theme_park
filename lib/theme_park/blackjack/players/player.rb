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

        def make_decision(_)
          :surrender
        end
      end
    end
  end
end
