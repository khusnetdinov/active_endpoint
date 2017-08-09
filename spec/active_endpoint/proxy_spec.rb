require 'pry'
require 'spec_helper'

RSpec.describe ActiveEndpoint::Proxy do
  let(:service) { described_class.new }

  let(:env_stub) do
    Rack::MockRequest.env_for('/test')
  end

  let(:block) { Proc.new { puts 'a'} }

  describe 'when whitelisted request' do
    it 'ok track without block' do
      # TODO: solve require issues and stub everything
      # expect_any_instance_of(ActiveEndpoint::Response).to receive(:new)

      # service.track(env_stub, &block)
    end
  end
end
