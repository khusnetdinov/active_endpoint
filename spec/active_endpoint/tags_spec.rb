require 'spec_helper'

RSpec.describe ActiveEndpoint::Tags do
  describe 'successfuly add tag' do
    let(:service) { described_class.new }
    let(:tag) { :hello_banana }
    let(:condition) { '/test/banana' }

    before { service.add(tag, condition) }

    it { expect(service.definition).to eq(tag => condition) }
  end
end
