require 'spec_helper'

RSpec.describe Configurable do
  module Test
    extend Configurable
  end

  describe '#configure' do
    before do
      Test.configure do |test|
        test.setting = :not_default
      end
    end

    subject { Test.setting }

    it { is_expected.to eql(:not_default) }
  end
end
