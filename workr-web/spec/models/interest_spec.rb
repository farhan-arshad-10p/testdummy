require 'spec_helper'

describe Interest do
  describe "associations" do
    describe "users" do
      it { should have_and_belong_to_many :users }
    end
  end

  describe "display name" do
    it "returns a human readable title for the record" do
      interest = Interest.new(name: 'Making Money')
      interest.display_name.should == 'Making Money'
    end
  end
end
