require 'spec_helper'

describe FeedPresenter do
  let(:uniq_results) {double}
  let(:results) {double(uniq: uniq_results)}
  subject { FeedPresenter }

  it 'returns a presented general feed' do
    results.stub(:total_pages) { 99 }
    results.stub(:next_page) { 28 }
    presented = subject.present(results, {query: "", keywords: "foo bar"})
    json = presented.as_json

    json.should include(id: "feed")
    json.should include(articles: uniq_results)
    presented.total_pages.should == 99
    presented.next_page.should == 28
  end

  it 'returns a presented general feed when on the first page of many' do
    results_array = [:feed_article, :another_feed_article]
    followed = [:followed_user_article, :another_followed_user_article]
    user = double

    results.stub(:total_pages) { 99 }
    results.stub(:next_page) { 2 }
    results.stub(:to_a) { results_array }

    ArticleManager.should_receive(:recent_following).with(user, 21) {followed}

    presented = subject.present(results, {query: "", keywords: "foo bar", current_user: user})
    json = presented.as_json

    json.should include(id: "feed")
    json.should include(articles: [followed, results_array].flatten)
    presented.total_pages.should == 99
    presented.next_page.should == 2
  end

  it 'returns a presented general feed when on the only page' do
    results_array = [:feed_article, :another_feed_article]
    followed = [:followed_user_article, :another_followed_user_article]
    user = double

    results.stub(:total_pages) { 1 }
    results.stub(:next_page) { nil }
    results.stub(:to_a) { results_array }

    ArticleManager.should_receive(:recent_following).with(user, 21) {followed}

    presented = subject.present(results, {query: "", keywords: "foo bar", current_user: user})
    json = presented.as_json

    json.should include(id: "feed")
    json.should include(articles: [followed, results_array].flatten)
    presented.total_pages.should == 1
    presented.next_page.should == nil
  end

  it 'returns a presented search feed' do
    results.stub(:total_pages) { 88 }
    results.stub(:next_page) { 33 }
    # Query and keywords should come in the same when its a search
    presented = subject.present(results, {query: "Apples banana", keywords: "Apples banana", content_type: "fruit"})
    json = presented.as_json

    json.should include(id: "search:fruit:apples-banana")
    json.should include(articles: uniq_results)
    presented.total_pages.should == 88
    presented.next_page.should == 33
  end

  it 'returns a presented search feed with no content type' do
    results.stub(:total_pages) { 88 }
    results.stub(:next_page) { 33 }
    # Query and keywords should come in the same when its a search
    presented = subject.present(results, {query: "Cheese", keywords: "Cheese"})
    json = presented.as_json

    json.should include(id: "search:all:cheese")
    json.should include(articles: uniq_results)
    presented.total_pages.should == 88
    presented.next_page.should == 33
  end
end
