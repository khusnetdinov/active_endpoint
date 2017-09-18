require 'spec_helper'

RSpec.describe Constraintable do
  let(:constraint_limit) { 22 }
  let(:constraint_period) { 22.minutes }
  let(:storage_limit) { 2222 }
  let(:storage_period) { 2.week }
  let(:rule) { { limit: constraint_limit, period: constraint_period } }
  let(:storage) { { limit: storage_limit, period: storage_period } }
  let(:constraints) { { rule: rule, storage: storage } }

  before do
    module Test
      extend Optionable
      extend Constraintable
    end

    ActiveEndpoint.configure do |config|
      config.constraint_limit = constraint_limit
      config.constraint_period = constraint_period
      config.storage_limit = storage_limit
      config.storage_period = storage_period
    end
  end

  describe '#constraints' do
    context 'default' do
      context 'rule constraints' do
        it 'containts default rule' do
          expect(Test.default_rule_constraints).to eq(rule)
        end

        it 'containts default storage' do
          expect(Test.default_storage_constraints).to eq(storage)
        end
      end
    end

    context 'part of defaults' do
      context 'rule' do
        it 'constraints rule' do
          constraints = Test.rule_constraints(rule: { limit: 300 })
          result = { limit: 300, period: constraint_period }
          expect(constraints).to eq(result)
        end
      end

      context 'storage' do
        it 'constrainrts storage' do
          constraints = Test.storage_constraints(storage: { period: 2.minutes })
          result = { limit: storage_limit, period: 2.minutes }
          expect(constraints).to eq(result)
        end
      end
    end

    context 'storage constraints' do
      subject { Test.constraints(constraints) }
      it { is_expected.to eq(constraints) }
    end
  end
end
