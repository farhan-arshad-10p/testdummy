require 'spec_helper'

describe ArticleManager do
  subject { ArticleManager }

  describe ".recent_following_articles" do
    let(:user) {Fabricate(:user)}
    let(:followed_user1) {Fabricate(:user)}
    let(:followed_user2) {Fabricate(:user)}
    before do
      user.following << followed_user1
      user.following << followed_user2
      user.save
    end

    it "returns the requested amount of articles from the users followed by the given user" do
      art2 = Fabricate(:article, user: followed_user1, created_at: 2.weeks.ago)
      art4 = Fabricate(:article, user: followed_user1, created_at: 5.weeks.ago)
      not_shown = Fabricate(:article, user: followed_user1, created_at: 11.weeks.ago)
      art3 = Fabricate(:article, user: followed_user2, created_at: 3.weeks.ago)
      art1 = Fabricate(:article, user: followed_user2, created_at: 1.weeks.ago)

      subject.recent_following(user, 4).should == [art1, art2, art3, art4]
    end

    it "returns 3 articles when no requested amount is given" do
      art2 = Fabricate(:article, user: followed_user1, created_at: 2.weeks.ago)
      not_shown = Fabricate(:article, user: followed_user1, created_at: 11.weeks.ago)
      art3 = Fabricate(:article, user: followed_user2, created_at: 3.weeks.ago)
      art1 = Fabricate(:article, user: followed_user2, created_at: 1.weeks.ago)

      subject.recent_following(user).should == [art1, art2, art3]
    end

    it "returns less than the requested amount when there are not enough clips" do
      art2 = Fabricate(:article, user: followed_user1, created_at: 2.weeks.ago)
      art1 = Fabricate(:article, user: followed_user2, created_at: 1.weeks.ago)

      subject.recent_following(user, 100).should == [art1, art2]
    end

    it "returns nothing" do
      subject.recent_following(user).should == []
    end
  end

  describe "create_from_content_source" do
    let(:collection) { Fabricate(:collection) }
    let(:args) { {user_id: collection.user_id, collection_ids: [collection.id]} }
    let(:content_source) { Fabricate(:content_source, title: "Bar", description: "Bar camp.", content_type: "html") }

    it "takes title/description from the content source when one doesnt exist" do
      article = subject.create_from_content_source(content_source, args) 
      article.title.should == "Bar"
      article.description.should == "Bar camp."
    end

    it "uses given title/description when passed in" do
      article = subject.create_from_content_source(content_source, args.merge(title: "My Title", description: "My Description")) 
      article.title.should == "My Title"
      article.description.should == "My Description"
    end

    it "returns the article with errors if there was an issue" do
      content_source.title = nil
      article = subject.create_from_content_source(content_source, args.merge(title: nil, description: "My Description")) 
      article.valid?.should be_false
    end

    it "gets it's type from the content source" do
      article = subject.create_from_content_source(content_source, args)
      article.class.should == HtmlArticle
    end
  end

  describe ".create" do
    it "should create a new article based on the given args" do
      collection = Fabricate(:collection)
      content_source = Fabricate(:content_source)
      article_args = {
        content_source_id: content_source.id, 
        user_id: 1337, 
        type: "HtmlArticle",
        title: "Brittle Bonez", 
        description: "I know we just met but I have brittle bone syndrome.", 
        random_content: "this should be ignored but ok",
        collection_ids: [collection.id],
      }

      subject.create(article_args)

      article = Article.find_by(user_id: 1337, content_source_id: content_source.id)
      article.should be
      article.content_source_id.should == content_source.id
      article.user_id.should == 1337
      article.title.should == "Brittle Bonez"
      article.description.should == "I know we just met but I have brittle bone syndrome."

      collection.reload.articles.should =~ [article]
    end
  end

  describe ".add_article_to_collection!" do
    it "should find the collection and tie the article to it" do
      collection = Fabricate(:collection)
      article = Fabricate(:article)
      collection.article_ids.should_not include(article.id)
      subject.add_article_to_collection!(article, collection.id)
      collection.article_ids.should include(article.id)
      collection.articles.length.should == 1

      subject.add_article_to_collection!(article, collection.id)
      collection.articles.length.should == 1
    end
  end


  describe ".search_keyword", search: true do
    it "should search the articles for the given keyword" do
      content_source1 = Fabricate(:content_source, content: "more stuff", url: "http://google.com")
      content_source2 = Fabricate(:content_source, content: "more stuff", url: "http://google.com/again")
      content_source3 = Fabricate(:content_source, content: "more stuff", url: "moregoogle.com")
      article_1 = Fabricate(:article, title: "Cat", description: "lots of stuff", content_source: content_source1)
      article_2 = Fabricate(:article, title: "More Cat", description: "more stuff", content_source: content_source2)
      another_article = Fabricate(:article, title: "Dogs", description: "more stuff", content_source: content_source3)

      Sunspot.commit

      article_ids = subject.search_keyword("Cat").map(&:id)

      article_ids.should include(article_1.id)
      article_ids.should include(article_2.id)
      article_ids.should_not include(another_article.id)
    end

    it "should use the article_search_settings" do
      WorkrSettings.first.should be_nil

      content_source1 = Fabricate(:content_source, content: "cow", url: "http://google.com")
      article_1 = Fabricate(:article, title: "Cat", description: "cow", content_source: content_source1)

      content_source2 = Fabricate(:content_source, content: "cat Cat cat Cat cat", url: "http://google.com/bar")
      article_2 = Fabricate(:article, title: "Cow", description: "Cat cat Cat cat Cat", content_source: content_source2)

      Sunspot.commit
      settings = Fabricate(:workr_settings, article_search_settings: "boost_fields title: 0.0, description: 10.0, content: 10.0")

      article_ids = subject.search_keyword("Cat").map(&:id)
      article_ids.should == [article_2.id, article_1.id]

      settings.article_search_settings = "boost_fields title: 10.0, description: 0.0, content: 0.0"
      settings.save!

      article_ids = subject.search_keyword("Cat").map(&:id)
      article_ids.should == [article_1.id, article_2.id]
    end
  end

  describe ".search_keywords", search: true do
    it "should search the articles for the given keywords and return unique articles" do
      content_source1 = Fabricate(:content_source, content: "Cats are the best", url: "http://google.com")
      content_source2 = Fabricate(:content_source, content: "I like my Donkey", url: "http://google.com/again")
      content_source3 = Fabricate(:content_source, content: "dogs...", url: "moregoogle.com")
      article_1 = Fabricate(:article, title: "Cat", description: "lots of stuff", content_source: content_source1)
      article_2 = Fabricate(:article, title: "Donkey", description: "more stuff", content_source: content_source2)
      another_article = Fabricate(:article, title: "Dogs", description: "more stuff", content_source: content_source3)

      Sunspot.commit

      article_ids = subject.search_keywords(["Cat", "Donkey"]).map(&:id)

      article_ids.should include(article_1.id)
      article_ids.should include(article_2.id)
      article_ids.should_not include(another_article.id)
    end

    it "should favor article ratings when 2 articles are equal" do
      content_source = Fabricate(:content_source, content: "Cats", url: "http://google.com")

      article_1 = Fabricate(:article, title: "Cat", description: "b", content_source: content_source)
      article_2 = Fabricate(:article, title: "Cat", description: "c", content_source: content_source)
      article_3 = Fabricate(:article, title: "Cat", description: "a", content_source: content_source)

      ArticleManager::RATING_THRESHOLD.times do 
        RatingsManager.create_or_update(user_id: Fabricate(:user).id, article_id: article_1.id, rating: 3)
        RatingsManager.create_or_update(user_id: Fabricate(:user).id, article_id: article_2.id, rating: 5)
        RatingsManager.create_or_update(user_id: Fabricate(:user).id, article_id: article_3.id, rating: 4)
      end

      Sunspot.commit

      article_ids = subject.search_keywords(["Cat"]).map(&:id)
      article_ids.should == [article_2.id, article_3.id, article_1.id]
    end
  end

  describe ".related_articles", search: true do
    it "returns the correct amount of similar articles" do
      content_source1 = Fabricate(:content_source, content: "Cats like to eat fish and chicken", url: "http://google.com")
      content_source2 = Fabricate(:content_source, content: "Donkeys eat grass and play in fields", url: "http://google.com/again")
      content_source3 = Fabricate(:content_source, content: "Dogs play in the grass and eat beef", url: "moregoogle.com")
      content_source4 = Fabricate(:content_source, content: "These guys eat cheese and run from cats", url: "moregoogle.com/foobar")
      article_1 = Fabricate(:article, title: "Cat", description: "Cats are different creatures", content_source: content_source1)
      article_2 = Fabricate(:article, title: "Donkey", description: "Chickens are friends of these animals", content_source: content_source2)
      article_3 = Fabricate(:article, title: "Dogs", description: "All about your furry friend", content_source: content_source3)
      article = Fabricate(:article, title: "Mice", description: "The little fellas in your barn", content_source: content_source4)

      Sunspot.commit

      related_results = subject.related_articles(article, 2)
      related_results.map(&:title).should == ['Cat', 'Donkey']
    end
  end

  describe ".increment_view_count" do
    it "should increment the view count of the given article" do
      article = double
      article.should_receive(:increment!).with(:view_count)

      subject.increment_view_count(article)
    end
  end


  describe ".user_rating" do
    it "should return the rating corresponding to the user" do
      article = Fabricate(:article)
      user = Fabricate(:user)
      rating = Rating.create(article: article, user: user, rating: 8)
      Rating.create(article: article, user: Fabricate(:user), rating: 8)

      subject.user_rating(article, user).should == rating
    end
    it "should return nil when the user has not rated" do
      article = Fabricate(:article)
      user = Fabricate(:user)
      Rating.create(article: article, user: Fabricate(:user), rating: 8)

      subject.user_rating(article, user).should be_nil
    end
  end
end
