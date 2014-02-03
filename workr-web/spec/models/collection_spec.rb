require 'spec_helper'

describe Collection do
  describe "associations" do
    describe "articles" do
      it { should have_and_belong_to_many :articles }
    end

    describe "users" do
      it { should belong_to :user }
    end
  end

  describe "validations" do
    it "should require a user" do
      collection = Fabricate.build(:collection)
      collection.user_id = nil
      collection.should_not be_valid

      collection.user_id = 1
      collection.should be_valid
    end

    it "should require a name" do
      collection = Fabricate.build(:collection, name: nil, user_id: 187)
      collection.should_not be_valid

      collection.name = "Choo Choo"
      collection.should be_valid
    end
  end

  describe "display name" do
    it "returns a human readable title for the record" do
      collection = Collection.new(name: 'Land of Oooo')
      collection.display_name.should == 'Land of Oooo'
    end
  end
end
