require 'spec_helper'

RSpec.describe ActiveEndpoint::Routes::Constraints do
  let(:rule) { { limit: 1, period: 2.seconds } }

  before do
    ActiveEndpoint.configure do |config|
      config.constraints.configure do |list|
        list.add(endpoint: 'test#index', rule: rule)
        list.add(resources: 'test_resource', rule: rule)
        list.add(resources: 'test_actions', actions: ['show'], rule: rule)
        list.add(scope: 'web', rule: rule)
      end
    end
  end

  describe '#add' do
    context 'endpoint' do
      subject { ActiveEndpoint.constraints.endpoints.keys }
      it { is_expected.to include('test#index') }
      it { is_expected.not_to include('test_resources#show') }
    end

    context 'resource' do
      subject { ActiveEndpoint.constraints.resources.keys }
      it { is_expected.to include('test_resource') }
      it { is_expected.not_to include('test#index') }
    end

    context 'action' do
      subject { ActiveEndpoint.constraints.actions.keys }
      it { is_expected.to include('test_actions#show') }
      it { is_expected.not_to include('test_actions#index') }
    end

    context 'scope' do
      subject { ActiveEndpoint.constraints.scopes.keys }
      it { is_expected.to include('web') }
      it { is_expected.not_to include('test') }
    end
  end
end
