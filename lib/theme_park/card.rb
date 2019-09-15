# frozen_string_literal: true

require 'types'

module ThemePark
  Suit = Types::String.enum('clubs', 'spades', 'hearts', 'diamonds')

  class Card < Dry::Struct
    Suit.values.each do |possible_suit|
      define_method "#{possible_suit}?" do
        suit == possible_suit
      end
    end
  end

  class Number < Card
    attribute :rank, Types::Integer.enum(*2..10)
    attribute :suit, Suit

    def value
      rank
    end
  end

  class Jack < Card
    attribute :suit, Suit

    def value
      10
    end
  end

  class Queen < Card
    attribute :suit, Suit

    def value
      10
    end
  end

  class King < Card
    attribute :suit, Suit

    def value
      10
    end
  end

  class Ace < Card
    attribute :suit, Suit

    def value
      11
    end
  end
end
