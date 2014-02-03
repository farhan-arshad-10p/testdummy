require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { Fabricate(:user) }
  let(:results) { double }
  let(:second_user) { Fabricate(:user) }
  let(:serialized_response) { double(as_json: {'foo' => 'bar'}) }
  before { login_user(user) }

  describe "index" do
    it 'searches the users' do
      results.stub(:total_pages) { 99 }
      results.stub(:next_page) { 5 }
      json = {'foo' => 'bar'}
      results.stub(:as_json) { json }
      UserManager.should_receive(:search_keywords) { results }

      get :index, { "query" => "Bobert", "page" => "3" }

      response.status.should == 200
      response.body.should_not be_blank
      JSON.parse(response.body).should == json
    end

    it 'searches for the first page of users'
    it 'returns the first 50 users'
  end

  describe "show" do
    it "serializes the user" do
      Api::V1::UserSerializer.should_receive(:new).with(user, anything) {serialized_response}
      get :show, id: user.id, format: :json
      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "should return errors if the user is not found" do
      User.stub(:find) { nil }
      get :show, id: 'broke', format: :json
      response.status.should == 404
    end
  end

  describe "#update" do
    it "returns the updated user" do
      follows = [1,3,4]
      UserManager.should_receive(:update_following).with(user, follows)
      user.should_receive(:update_attributes).with({'first_name' => 'foo'}) {true}

      Api::V1::UserSerializer.should_receive(:new).with(user, anything) {serialized_response}

      put :update, id: 123, user: {first_name: 'foo', following: follows}, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns the errors" do
      user.should_receive(:update_attributes).with({'first_name' => 'foo'}) {false}
      user.stub(:errors) { {first_name: ['missing!']} }

      Api::V1::UserSerializer.should_receive(:new) do |arg1, arg2|
        arg1.should == user
        arg2[:status].should == 422
        arg2[:meta].should == {:first_name => ["missing!"]}
        arg2[:meta_key].should == "errors"
        serialized_response
      end

      put :update, id: 123, user: {first_name: 'foo'}, format: :json

      response.status.should == 422
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end
  end

  describe "followers" do
    it "should return the user's followers" do
      user.stub(:followers) { [:followers] }
      get :followers, id: user.id, format: :json
      response.status.should == 200
      JSON.parse(response.body).should ==  {'users' => []}
    end

    it "should return errors if the user is not found" do
      User.stub(:find) { nil }
      get :followers, id: 'broke', format: :json
      response.status.should == 404
    end
  end

  describe "following" do
    it "should return the users that are being followed" do
      user.stub(:following) { [:following] }
      get :following, id: user.id, format: :json
      response.status.should == 200
      JSON.parse(response.body).should ==  {'users' => []}
    end

    it "should return errors if the user is not found" do
      User.stub(:find) { nil }
      get :following, id: 'broke', format: :json
      response.status.should == 404
    end
  end
end
