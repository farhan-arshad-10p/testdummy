require 'spec_helper'

describe User do
  describe "associations" do
    it { should have_many :collections }
    it { should have_many :articles }
    it { should have_many :flags }
    it { should have_and_belong_to_many :interests }
    it { should have_many(:follower_relationships).dependent(:destroy) }
    it { should have_many(:followed_relationships).dependent(:destroy) }
    it { should have_many(:following).through(:follower_relationships) }
    it { should have_many(:followers).through(:followed_relationships) }
    it { should validate_attachment_content_type(:avatar)
      .allowing(*User::SUPPORTED_AVATAR_TYPES)
      .rejecting('text/rtf')
    }
  end

  describe "validation" do
    it "is invalid if the user has not accepted the TOS" do
      user = Fabricate.build(:user, terms_of_service: false)
      user.should_not be_valid
      user.terms_of_service = true
      user.should be_valid
    end

    it "is invalid if no first name is given" do
      user = Fabricate.build(:user, first_name: '')
      user.should_not be_valid
      user.first_name = 'Megan'
      user.should be_valid
    end

    it "is invalid if no last name is given" do
      user = Fabricate.build(:user, last_name: '')
      user.should_not be_valid
      user.last_name = 'VanKlompenStienBergHoven'
      user.should be_valid
    end

    it "is invalid if no interests are selected" do
      user = Fabricate.build(:user, interests: [])
      user.should_not be_valid
      user.interests = [Fabricate(:interest)]
      user.should be_valid
    end
  end

  describe "display_name" do
    it "returns the user's email" do
      user = User.new(email: 'foo@bar.com')
      user.display_name.should == 'foo@bar.com'
    end
  end

  describe "full_name" do
    it "returns the user's full name" do
      user = User.new(first_name: 'Jeffrey', last_name: 'Dallas')
      user.full_name.should == 'Jeffrey Dallas'
    end
  end
end
