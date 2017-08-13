require 'spec_helper'

RSpec.describe ActiveEndpoint::Routes::Blacklist do
  before do
    ActiveEndpoint.configure do |config|
      config.blacklist.configure do |list|
        list.add(endpoint: 'test#index')
        list.add(resources: 'test_resource')
        list.add(resources: 'test_actions', actions: ['show'])
        list.add(scope: 'web')
      end
    end
  end

  describe '#add' do
    context 'endpoint' do
      subject { ActiveEndpoint.blacklist.endpoints }
      it { is_expected.to include('test#index') }
      it { is_expected.not_to include('test_resources#show') }
    end

    context 'resource' do
      subject { ActiveEndpoint.blacklist.resources }
      it { is_expected.to include('test_resource') }
      it { is_expected.not_to include('test#index') }
    end

    context 'action' do
      subject { ActiveEndpoint.blacklist.actions }
      it { is_expected.to include('test_actions#show') }
      it { is_expected.not_to include('test_actions#index') }
    end

    context 'scope' do
      subject { ActiveEndpoint.blacklist.scopes }
      it { is_expected.to include('web') }
      it { is_expected.not_to include('test') }
    end
  end
end
