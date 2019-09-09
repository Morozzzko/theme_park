# frozen_string_literal: true

require 'theme_park/deck'

RSpec.describe ThemePark::Deck do
  describe '#create' do
    subject { ThemePark::Deck.create }

    specify do
      expect(subject).to be_an Array
      expect(subject.length).to eql 52

      expect(subject.count(&:spades?)).to eql(13)
      expect(subject.count(&:clubs?)).to eql(13)
      expect(subject.count(&:hearts?)).to eql(13)
      expect(subject.count(&:diamonds?)).to eql(13)
    end
  end
end
