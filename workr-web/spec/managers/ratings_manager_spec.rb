
require 'spec_helper'

describe RatingsManager do
  let!(:user) { Fabricate(:user) }
  let!(:article) { Fabricate(:article) }
  let!(:rating) { Fabricate(:rating) }

  describe "#create_or_update" do
    it "should create the rating on article and reindex article" do
      Sunspot.should_receive(:index).with(article)
      Sunspot.should_receive(:commit)

      RatingsManager.create_or_update(article_id: article.id, user_id: user.id, rating: 99)

      article.reload.ratings.count.should == 1
      article.ratings.first.rating.should == 99
      article.ratings.first.user.should == user
    end
  end
end
