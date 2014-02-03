require 'spec_helper'

describe Article do
  describe "#average_rating" do
    it "should return the average" do
      article = Fabricate(:article)
      Rating.create!(article: article, user: Fabricate(:user), rating: 8)
      Rating.create!(article: article, user: Fabricate(:user), rating: 4)
      article.average_rating.should == 6
    end

    it "should return 0 when there are no ratings" do
      article = Fabricate(:article)
      subject.average_rating.should == 0
    end
  end

  describe "validations" do
    it { should have_many :tags }

    it "must have a user" do
      article = Fabricate(:article)
      article.user_id = nil
      article.should_not be_valid

      article.user = Fabricate(:user)
      article.should be_valid
    end

    it "must have a type" do
      article = Fabricate(:article)
      article.type = nil
      article.should_not be_valid
    end

    it "must have a content_source" do
      article = Fabricate(:article)
      article.content_source_id = nil
      article.should_not be_valid

      article.content_source = Fabricate(:content_source)
      article.should be_valid
    end

    it "must have at least one collection" do
      article = Fabricate(:article)
      article.collections = []
      article.should_not be_valid

      article.collections << Fabricate(:collection)
      article.should be_valid
      article.collections << Fabricate(:collection)
      article.should be_valid
    end

    it "must have a title" do
      article = Fabricate(:article)
      article.title = ''
      article.should_not be_valid

      article.title = 'foo'
      article.should be_valid
    end

    it "must have a description" do
      article = Fabricate(:article)
      article.description = ''
      article.should_not be_valid

      article.description = 'foo'
      article.should be_valid
    end
  end

  describe "associations" do
    it { should have_and_belong_to_many :collections }
    it { should belong_to :content_source }
    it { should belong_to :user }
    it { should have_many :views }
    it { should have_many(:viewed_articles).dependent(:destroy) }
    it { should have_many(:ratings).dependent(:destroy) }
  end

  describe "display name" do
    it "returns a human readable title for the record" do
      article = Article.new(title: 'How to skin a bear')
      article.display_name.should == 'How to skin a bear'
    end
  end
end
