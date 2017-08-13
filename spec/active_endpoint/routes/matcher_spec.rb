require 'spec_helper'

RSpec.describe ActiveEndpoint::Routes::Matcher do
  let(:request) { double('Request', probe: { endpoint: 'welcome#index' }) }
  let(:cache_store) { double('Cache::Store') }
  let(:constraint_rule) { double('ConstraintRule', rule: Hash.new) }
  let(:matcher) { described_class.new }

  before do
    allow(ActiveEndpoint::Routes::ConstraintRule).to receive(:new).and_return(constraint_rule)
    allow(ActiveEndpoint::Routes::Cache::Store).to receive(:new).and_return(cache_store)
    allow(cache_store).to receive(:allow?).and_return(true)
    allow(cache_store).to receive(:unregistred?).and_return(true)
    allow(request).to receive(:path).and_return('/')
  end

  describe '#whitelisted?' do
    subject { matcher.whitelisted?(request) }
    xit { is_expected.to be_falsey }
  end

  describe '#blacklisted' do
    let(:probe) { { endpoint: 'welcome#index' }}
    context 'ignored' do
      subject { matcher.blacklisted?(probe) }
      it { is_expected.to be_falsey }
    end

    context 'not ignored' do
      subject { matcher.blacklisted?(probe) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#unregistred?' do
    subject { matcher.unregistred?(request) }
    xit { is_expected.to be_falsey }
  end

  describe '#assets?' do
    let(:probe) { double('Probe', path: '/assets') }
    subject { matcher.assets?(probe) }
    it { is_expected.to be_truthy }
  end

  describe '#allow_account?' do
    subject { matcher.allow_account?(request) }
    it { is_expected.to be_truthy }
  end

  describe '#allow_register?' do
    subject { matcher.allow_register?(request) }
    it { is_expected.to be_truthy }
  end
end
