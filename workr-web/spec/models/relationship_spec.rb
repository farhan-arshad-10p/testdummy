require 'spec_helper'

describe Relationship do
  describe "follower methods" do
    let(:followed) { Fabricate(:user) }
    let(:follower) { Fabricate(:user) }

    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    it 'should assign followers properly' do
      rel = Relationship.new(follower_id: follower.id, followed_id: followed.id)

      rel.followed.should == followed
      rel.follower.should == follower
    end
  end
end
