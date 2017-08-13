require 'spec_helper'

RSpec.describe Configurable do
  module Test
    extend Configurable

    define_setting :setting, :default
  end

  subject { Test.setting }

  describe '#define_setting' do
    it { is_expected.to eql(:default) }
  end

  describe'#configure' do
    before do
      Test.configure do |test|
        test.setting = :not_default
      end
    end

    it { is_expected.to eql(:not_default)}
  end
end
