require 'spec_helper'

describe ViewedArticle do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :article }
  end

  describe "validations" do
    it "must have a user" do
      viewed_article = Fabricate(:viewed_article)
      viewed_article.user_id = nil
      viewed_article.should_not be_valid

      viewed_article.user = Fabricate(:user)
      viewed_article.should be_valid
    end

    it "must have a article" do
      viewed_article = Fabricate(:viewed_article)
      viewed_article.article_id = nil
      viewed_article.should_not be_valid

      viewed_article.article = Fabricate(:article)
      viewed_article.should be_valid
    end
  end
end
