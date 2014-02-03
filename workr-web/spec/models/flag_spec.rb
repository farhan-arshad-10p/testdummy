require 'spec_helper'

describe Flag do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :article }
  end

  describe "validations" do
    it "must have a user" do
      flag = Fabricate(:flag)
      flag.user_id = nil
      flag.should_not be_valid

      flag.user = Fabricate(:user)
      flag.should be_valid
    end

    it "must have a article" do
      flag = Fabricate(:flag)
      flag.article_id = nil
      flag.should_not be_valid

      flag.article = Fabricate(:article)
      flag.should be_valid
    end
  end
end
