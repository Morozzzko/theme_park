# frozen_string_literal: true

RSpec.shared_examples 'card' do
  describe '#hide' do
    specify do
      expect(card.hide).to eql(
        ThemePark::HiddenCard[
          original: card
        ]
      )
    end
  end
end
