# frozen_string_literal: true

require 'theme_park/deck'

RSpec.describe ThemePark::Deck do
  describe '#create' do
    subject(:deck) { described_class.create }

    it 'creates an array of 52 cards' do
      expect(deck).to be_an Array
      expect(deck.length).to be 52
    end

    it 'evenly distributes all 4 suits' do
      expect(deck.count(&:spades?)).to be(13)
      expect(deck.count(&:clubs?)).to be(13)
      expect(deck.count(&:hearts?)).to be(13)
      expect(deck.count(&:diamonds?)).to be(13)
    end
  end
end
