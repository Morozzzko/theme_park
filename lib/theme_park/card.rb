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

    def hide
      HiddenCard[original: self]
    end
  end

  class HiddenCard < Card
    attribute :original, Card

    def to_ascii_card
      %i[hidden hidden hidden]
    end
  end

  class Number < Card
    attribute :rank, Types::Integer.enum(*2..10)
    attribute :suit, Suit

    def value
      rank
    end

    def to_ascii_card
      [rank, suit.to_sym]
    end
  end

  class Jack < Card
    attribute :suit, Suit

    def value
      10
    end

    def to_ascii_card
      [:jack, suit.to_sym]
    end
  end

  class Queen < Card
    attribute :suit, Suit

    def value
      10
    end

    def to_ascii_card
      [:queen, suit.to_sym]
    end
  end

  class King < Card
    attribute :suit, Suit

    def value
      10
    end

    def to_ascii_card
      [:king, suit.to_sym]
    end
  end

  class Ace < Card
    attribute :suit, Suit

    def value
      11
    end

    def to_ascii_card
      [:ace, suit.to_sym]
    end
  end
end
