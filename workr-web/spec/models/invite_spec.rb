require 'spec_helper'

describe Invite do
  describe "associations" do 
    describe "user" do
      it { should belong_to :user }
    end
  end

  describe "scopes" do
    describe "active" do
      it "should return all active and ignore non active" do
        invite = Fabricate(:invite)
        inactive_invite = Fabricate(:invite, active: false)

        invite_ids = Invite.active.map(&:id)
        invite_ids.should include(invite.id)
        invite_ids.should_not include(inactive_invite.id)
      end
    end
  end

  describe "validations" do
    it "requires the code to be unique" do
      invite = Fabricate(:invite, code: "abc123")
      another_invite = Fabricate(:invite, code: "abc")

      another_invite.should be_valid
      another_invite.code = "abc123"
      another_invite.should_not be_valid
    end

    it "requires the code to be present" do
      invite = Fabricate(:invite, code: "abc123")
      

      invite.should be_valid
      invite.code = ""
      invite.should_not be_valid
    end

  end

  describe "#code" do 
    it "should generate a code with a new record" do
      invite = Invite.new
      invite.code.should be_present
    end
  end
end
