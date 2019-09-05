# frozen_string_literal: true

require 'types'

module ThemePark
  Suit = Types::String.enum('clubs', 'spades', 'hearts', 'diamonds')

  class Number < Dry::Struct
    attribute :rank, Types::Integer.enum(*2..10)
    attribute :suit, Suit
  end

  class Jack < Dry::Struct
    attribute :suit, Suit
  end

  class Queen < Dry::Struct
    attribute :suit, Suit
  end

  class King < Dry::Struct
    attribute :suit, Suit
  end

  class Ace < Dry::Struct
    attribute :suit, Suit
  end

  Card = Number | Jack | Queen | King | Ace
end
