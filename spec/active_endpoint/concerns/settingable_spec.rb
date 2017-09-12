require 'spec_helper'

RSpec.describe Settingable do
  module Test
    extend Settingable

    define_setting :setting, :default
  end

  before do
    Test.configure do |test|
      test.setting = :not_default
    end
  end

  describe '#define_setting' do
    subject { Test.setting }
    it { is_expected.to eql(:not_default) }
  end
end
