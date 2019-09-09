# frozen_string_literal: true

require 'types'

module ThemePark
  Suit = Types::String.enum('clubs', 'spades', 'hearts', 'diamonds')

  class PlayableCard < Dry::Struct
    Suit.values.each do |possible_suit|
      define_method "#{possible_suit}?" do
        suit == possible_suit
      end
    end
  end

  class Number < PlayableCard
    attribute :rank, Types::Integer.enum(*2..10)
    attribute :suit, Suit
  end

  class Jack < PlayableCard
    attribute :suit, Suit
  end

  class Queen < PlayableCard
    attribute :suit, Suit
  end

  class King < PlayableCard
    attribute :suit, Suit
  end

  class Ace < PlayableCard
    attribute :suit, Suit
  end

  Card = Number | Jack | Queen | King | Ace
end
