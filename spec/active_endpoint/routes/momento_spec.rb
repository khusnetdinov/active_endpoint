require 'spec_helper'

RSpec.describe ActiveEndpoint::Routes::Momento do
  describe '#initialize' do
    subject { described_class.new(Array).scopes }
    it { is_expected.to eql([]) }
  end
end
