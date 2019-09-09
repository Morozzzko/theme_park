# frozen_string_literal: true

require 'theme_park/card'

module ThemePark
  Deck = Types::Array.of(Card)

  class << Deck
    def create
      self[
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
