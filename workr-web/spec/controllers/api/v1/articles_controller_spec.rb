require 'spec_helper'

describe Api::V1::ArticlesController do
  let(:user) { Fabricate(:user) }
  let(:article) { Fabricate(:article) }
  let(:article_double) { double }
  let(:serialized_response) { double(as_json: {'foo' => 'bar'}) }
  before { login_user(user) }

  describe "index" do
    let(:scoped_article) {double}
    let(:articles) {double}
    before do
      Article.should_receive(:includes).with([:user, :collections, :content_source, :tags]) { scoped_article }
    end

    it "returns the requested articles" do
      ids = ["1", "2", "3", "10"]
      # Apparently Each serializer is not being called as expected?
      scoped_article.should_receive(:where).with(["id in (?)", ids]) {serialized_response}

      get :index, ids: ids

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns the top 100 articles when no request is made" do
      # Apparently Each serializer is not being called as expected?
      scoped_article.should_receive(:limit).with(100) {serialized_response}

      get :index

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end
  end

  describe "show" do
    it "serializes the collection" do
      Api::V1::ArticleSerializer.should_receive(:new).with(article, anything) {serialized_response}
      get :show, id: article.id, format: :json
      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "fails when the article is not found"
  end


  describe "create" do
    let(:content_source) {double}
    let(:article) {double}
    it "creates the article and returns it" do
      collection_ids = "9"
      safe_article_params = { title: "moo", description: "meow", tag_list: "all,the,tags" }
      article_params = {content_source_id: "1256", collection: collection_ids}.merge(safe_article_params)
      additional_params = {user_id: user.id, collection_ids: collection_ids}

      ContentSource.should_receive(:find).with("1256") { content_source }
      ArticleManager.should_receive(:create_from_content_source).with(content_source, safe_article_params.merge(additional_params).stringify_keys) { article }
      article.stub(:valid?) { true }

      Api::V1::ArticleSerializer.stub(:new) { serialized_response }

      post :create, article: article_params, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns the errors" do
      collection_ids = "9"
      safe_article_params = { title: "moo", description: "meow" }
      article_params = {content_source_id: "1256", collection: collection_ids}.merge(safe_article_params)
      additional_params = {user_id: user.id, collection_ids: collection_ids}

      ContentSource.should_receive(:find).with("1256") { content_source }
      ArticleManager.should_receive(:create_from_content_source).with(content_source, safe_article_params.merge(additional_params).stringify_keys) { article }
      article.stub(:valid?) { false }
      article.stub(:errors) { {description: ['too boring']} }

      Api::V1::ArticleSerializer.stub(:new) do |arg1, arg2|
        arg1.should == article
        arg2[:status].should == 422
        arg2[:meta].should == {:description => ["too boring"]}
        arg2[:meta_key].should == "errors"
        serialized_response 
        serialized_response 
      end

      post :create, article: article_params, format: :json

      response.status.should == 422
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end
  end
  
  describe "destroy" do
    it "fails when the article is not found" do
      Article.stub(:find) { nil }

      delete :destroy, id: 1923, format: :json

      response.status.should == 404
    end

    it "deletes the record" do
      Api::V1::ArticleSerializer.should_receive(:new).with(article_double, anything) {serialized_response}

      Article.stub(:find).with("123") { article_double }
      article_double.stub(:destroy) {true}

      delete :destroy, id: 123, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns errors when the record cannot be deleted" do
      Article.stub(:find).with("123") { article_double }
      article_double.stub(:destroy) {false}
      delete :destroy, id: 123, format: :json

      response.status.should == 422
    end
  end

  describe "related_articles" do
    it "fails when the article is not found" do
      Article.stub(:find) { nil }

      get :related_articles, id: 1923, format: :json

      response.status.should == 404
    end

    it "returns the related articles" do
      Article.stub(:find).with("123") { article_double }
      ArticleManager.stub(:related_articles).with(article_double, 3) {serialized_response}
      get :related_articles, id: 123, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end
  end

  describe "update" do
    let(:article) { double(errors: {boom: "boom"}) }
    let(:article_id) { "10" }
    let(:serialized_response) { {foo: "bar"} }
    let(:article_params) { { "title" => "new title" } } 

    before do
      Article.stub(:find).with(article_id) { article } 
    end

    describe "with a valid article" do
      it "should update the article and serialize it as the response" do
        article.should_receive(:update_attributes).with("title" => "new title") { true }
        Api::V1::ArticleSerializer.stub(:new) { serialized_response }

        put :update, id: article_id, article: article_params, format: :json

        response.status.should == 200
        JSON.parse(response.body).should ==  {'foo' => 'bar'}
      end
    end

    describe "with a invalid article" do
      it "should update the article and serialize it as the response" do
        article.should_receive(:update_attributes).with("title" => "new title") { false }
        Api::V1::ArticleSerializer.stub(:new) { serialized_response }

        put :update, id: article_id, article: article_params, format: :json

        response.status.should == 422
        JSON.parse(response.body).should ==  {'foo' => 'bar'}
      end
    end
  end
end
