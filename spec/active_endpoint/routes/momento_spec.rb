require 'spec_helper'

RSpec.describe ActiveEndpoint::Routes::Momento do
  describe '#initialize' do
    subject { described_class.new(Array).scopes }
    it { is_expected.to eql([]) }
  end

  describe '#any_presented?' do
    context 'truthy' do
      subject { described_class.new(Array).send(:any_presented?, [false, false, true]) }
      it { is_expected.to be_truthy }
    end

    context 'falsey' do
      subject { described_class.new(Array).send(:any_presented?, [false, false, false]) }
      it { is_expected.to be_falsey }
    end
  end
end
