require 'spec_helper'
describe Api::V1::InterestSerializer do
  subject { described_class.new interest, root: :interest }
  let(:interest) { Fabricate(:interest) }

  describe '#as_json' do
    it 'serializes the model properly' do
     subject.as_json.should == {interest: {
                                 id: interest.id,
                                 name: interest.name
                                } }
    end
  end
end
