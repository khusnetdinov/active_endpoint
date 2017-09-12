require 'spec_helper'

RSpec.describe RailsRoutable do
  let(:request) { Hash.new }
  let(:action) { {controller: 'web/welcome', action: 'index'} }

  before do
    module Test
      extend RailsRoutable
    end

    allow(Test).to receive(:rails_action).and_return(action)
  end

  describe '#rails_action?' do
    it { is_expected.to be_truthy }
  end

  describe '#rails_request_params' do
    subject { Test.rails_request_params(request) }
    it { is_expected.to eql({}) }
  end

  describe '#rails_endpoint' do
    subject { Test.rails_endpoint(request) }
    it { is_expected.to eql(action) }
  end

  describe '#rails_action' do
  end

  describe '#rails_route_pattern' do
  end

  describe '#rails_routes' do
  end
end
