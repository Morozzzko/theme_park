# frozen_string_literal: true

require 'theme_park/card'

module ThemePark
  module Deck
    Type = Types::Array.of(Card)

    class << self
      def [](*args)
        Type[*args]
      end

      def new(*args)
        Type.new(*args)
      end

      def create
        Type[
          Suit.values.flat_map do |suit|
            [
              Ace[suit: suit],
              King[suit: suit],
              Queen[suit: suit],
              Jack[suit: suit],
              *(2..10).map { |rank| Number[suit: suit, rank: rank] }
            ]
          end
        ].shuffle
      end
    end
  end
end
