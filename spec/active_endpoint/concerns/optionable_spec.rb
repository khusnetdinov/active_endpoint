require 'spec_helper'

RSpec.describe Optionable do
  let(:empty_options) { Hash.new }

  [
    :endpoint,
    :actions,
    :resources,
    :scope,
    :limit,
    :period,
    :storage,
    :rule
  ].each do |method|
    describe "#fetch_#{method}" do
      let(:object) { Object.new }
      let(:options) { { method => true } }

      before do
        object.extend(described_class)
      end

      context 'if exists option' do
        subject { object.send("fetch_#{method}".to_sym, options) }
        it { is_expected.to be_truthy }
      end

      context 'if option empty' do
        subject { object.send("fetch_#{method}".to_sym, empty_options) }
        it { is_expected.to be_falsey }
      end
    end
  end
end
