require 'spec_helper'

describe UserManager do
  subject { UserManager }

  describe ".update_following" do
    let(:user) {Fabricate(:user)}

    it "adds follows (int ids)" do
      new_follow = Fabricate(:user)
      user.following.count.should == 0

      subject.update_following(user, [new_follow.id])

      user.following.reload.count.should == 1
      user.following.should == [new_follow]
    end

    it "adds follows (string ids)" do
      new_follow = Fabricate(:user)
      user.following.count.should == 0

      subject.update_following(user, [new_follow.id.to_s])

      user.following.reload.count.should == 1
      user.following.should == [new_follow]
    end

    it "removes follows (handles empty array)" do
      new_follow = Fabricate(:user)
      user.following << new_follow

      user.following.reload.count.should == 1
      user.following.should == [new_follow]

      subject.update_following(user, [])

      user.following.reload.count.should == 0
    end

    it "removes follows (handles empty nil)" do
      new_follow = Fabricate(:user)
      user.following << new_follow

      user.following.reload.count.should == 1
      user.following.should == [new_follow]

      subject.update_following(user, nil)

      user.following.reload.count.should == 0
    end
  end
  
  describe ".search_keywords", search: true do
    it "returns the users that match the search" do
      user1 = Fabricate(:user, first_name: "James", last_name: "Smith", email: "js@foobar.com")
      user2 = Fabricate(:user, first_name: "Alex", last_name: "Sweeny", email: "as@foobar.com")
      user3 = Fabricate(:user, first_name: "Andy", last_name: "Mcdonald", email: "am@foobar.com")

      Sunspot.commit

      user_ids = subject.search_keywords(["James", "Sweeny"]).map(&:id)

      user_ids.should include(user1.id)
      user_ids.should include(user2.id)
      user_ids.should_not include(user3.id)
    end
  end
end
