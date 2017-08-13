require 'spec_helper'

RSpec.describe ActiveEndpoint::Routes::ConstraintRule do
  let(:request) do
    {
      endpoint: 'test#index'
    }
  end

  let(:rule) do
    {
      key: 'defaults:test#index',
      rule: { limit: ActiveEndpoint.constraint_limit, period: ActiveEndpoint.constraint_period },
      storage: { limit: ActiveEndpoint.storage_limit, period: ActiveEndpoint.storage_period }
    }
  end

  describe '#rule' do
    describe ':key' do
      subject { ActiveEndpoint::Routes::ConstraintRule.new(request).rule[:key] }
      it { is_expected.to eql(rule[:key]) }
    end

    describe ':rule' do
      subject { ActiveEndpoint::Routes::ConstraintRule.new(request).rule[:rule] }
      it { is_expected.to eq(rule[:rule]) }
    end

    describe ':storage' do
      subject { ActiveEndpoint::Routes::ConstraintRule.new(request).rule[:storage] }
      it { is_expected.to eq(rule[:storage]) }
    end
  end
end
