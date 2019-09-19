# frozen_string_literal: true

RSpec.shared_examples 'ascii card' do
  describe '#to_ascii_card' do
    specify do
      expect(card.to_ascii_card).to eql(expected)
    end
  end
end
