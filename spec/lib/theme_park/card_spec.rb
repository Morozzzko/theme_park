# frozen_string_literal: true

require 'theme_park/deck'

RSpec.describe ThemePark::Card do
  subject(:card) { described_class.new(suit: 'hearts') }

  describe ThemePark::Jack do
    it_behaves_like 'card'
    it_behaves_like 'ascii card' do
      let(:expected) { %i[jack hearts] }
    end
  end

  describe ThemePark::Queen do
    it_behaves_like 'card'
    it_behaves_like 'ascii card' do
      let(:expected) { %i[queen hearts] }
    end
  end

  describe ThemePark::King do
    it_behaves_like 'card'
    it_behaves_like 'ascii card' do
      let(:expected) { %i[king hearts] }
    end
  end

  describe ThemePark::Ace do
    it_behaves_like 'card'
    it_behaves_like 'ascii card' do
      let(:expected) { %i[ace hearts] }
    end
  end

  describe ThemePark::Number do
    it_behaves_like 'card'
    subject(:card) do
      described_class.new(suit: 'hearts', rank: 7)
    end

    it_behaves_like 'ascii card' do
      let(:expected) { [7, :hearts] }
    end
  end

  describe ThemePark::HiddenCard do
    subject(:card) do
      described_class.new(
        original: original
      )
    end

    let(:original) do
      ThemePark::Ace[suit: 'diamonds']
    end

    describe '#original' do
      specify do
        expect(card.original).to be(original)
      end
    end

    it_behaves_like 'ascii card' do
      let(:expected) { %i[hidden hidden hidden] }
    end
  end
end
