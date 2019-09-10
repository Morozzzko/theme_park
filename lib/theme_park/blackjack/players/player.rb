# frozen_string_literal: true

require 'types'
require 'theme_park/card'

module ThemePark
  module Blackjack
    module Players
      class Player < Dry::Struct
        attribute :hand, Types::Array.of(Card)
      end
    end
  end
end
