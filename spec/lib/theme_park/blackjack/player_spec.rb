# frozen_string_literal: true

require 'theme_park/deck'
require 'theme_park/blackjack/player'

RSpec.describe ThemePark::Blackjack::Player do
  subject(:player) do
    described_class.new(hand: hand, name: 'Han')
  end

  let(:hand) { [] }

  it_behaves_like 'blackjack player'

  describe '#surrender' do
    subject(:surrender) { player.surrender }

    specify do
      expect(surrender).to be_a(described_class)
      expect(surrender).not_to be(player)
      expect(surrender.state).to be(:surrendered)
    end
  end

  describe '#stand' do
    subject(:stand) { player.stand }

    specify do
      expect(stand).to be_a(described_class)
      expect(stand).not_to be(player)
      expect(stand.state).to be(:standing)
    end
  end
end
