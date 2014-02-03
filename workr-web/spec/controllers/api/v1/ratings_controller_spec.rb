require 'spec_helper'

describe Api::V1::RatingsController do
  let(:user) { Fabricate(:user) }
  let(:article) { Fabricate(:article) }
  let(:rating) { Fabricate(:rating) }

  before { login_user(user) }

  describe "create" do
    it "creates the rating and returns a 200" do
      rating_params = { article: "10", rating: 99 }

      RatingsManager.should_receive(:create_or_update).with(article_id: "10", user_id: user.id, rating: 99) { true }
      post :create, rating: rating_params, format: :json

      response.status.should == 200
    end
  end

  describe "show" do
    it "returns the rating" do
      get :show, id: rating.id

      response.status.should == 200
      JSON.parse(response.body).should == {"rating"=>{"id"=> rating.id, "user"=> rating.user.id, "article"=>rating.article.id, "rating"=>rating.rating}}
    end
  end
end

