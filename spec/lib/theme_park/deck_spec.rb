# frozen_string_literal: true

require 'theme_park/deck'

RSpec.describe ThemePark::Deck do
  describe '#create' do
    subject { ThemePark::Deck.create }

    specify do
      expect(subject).to be_an Array
      expect(subject.length).to eql 52
    end
  end
end
