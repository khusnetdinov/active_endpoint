require 'spec_helper'

RSpec.describe ActiveEndpoint::Tags do
  describe '#add' do
    let(:tag_name) { :tag_name }
    let(:definition) { :definition }
    let(:tags) { ActiveEndpoint::Tags.new }

    before do
      tags.configure do |tag|
        tag.add(tag_name, definition)
      end
    end

    subject { tags.definition[tag_name] }

    it { is_expected.to eql(definition) }
  end
end
