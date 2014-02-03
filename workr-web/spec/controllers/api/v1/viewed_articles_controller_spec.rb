require 'spec_helper'

describe Api::V1::ViewedArticlesController do
  let(:user) { Fabricate(:user) }
  let(:article) { Fabricate(:article) }

  before { login_user(user) }

  describe "create" do
    it "creates the viewed article and returns a 200" do
      viewed_article_params = { article: article.id }

      post :create, viewed_article: viewed_article_params, format: :json

      user.reload.viewed_articles.count.should == 1
      viewed_articles = user.viewed_articles
      viewed_articles.map { |va| va.article_id }.should include(article.id)
      response.status.should == 200
    end
  end

  describe "index" do
    it "should return the users 5 most recent viewed articles" do
      get :index, user_id: user.id

      response.status.should == 200
      JSON.parse(response.body).should == {"viewed_articles" => []} end
  end
end
