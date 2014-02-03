require 'spec_helper'

describe Api::V1::CollectionsController do
  let(:user) { Fabricate(:user) }
  let(:collection) { Fabricate(:collection) }
  let(:collection_double) { double }
  let(:serialized_response) { double(as_json: {'foo' => 'bar'}) }
  before { login_user(user) }

  describe "index" do
    let(:collections) {double}
    let(:collection_includes) {double}
    before do
      Collection.should_receive(:includes).with(:user) {collection_includes}
    end

    it "returns the requested collections" do
      ids = ["5", "3", "9", "10"]
      collection_includes.should_receive(:where).with(["id in (?)", ids]) {serialized_response}

      get :index, ids: ids

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns collections for the given user" do
      collection_includes.should_receive(:where).with(user_id: '123') {serialized_response}

      get :index, user_id: '123'

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns the top 100 collections when no request is made" do
      collection_includes.should_receive(:limit).with(100) {serialized_response}

      get :index

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end
  end

  describe "show" do
    it "serializes the collection" do
      Api::V1::CollectionSerializer.should_receive(:new).with(collection, anything) {serialized_response}

      get :show, id: collection.id, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "fails when the collection is not found" do
      Collection.stub(:find) { nil }

      get :show, id: 1923, format: :json

      response.status.should == 404
    end
  end

  describe "create" do
    it "returns the new collection" do
      Collection.should_receive(:new).with({"name" => 'foo', "description" => 'bar', "user" => user}) {collection_double}
      Api::V1::CollectionSerializer.should_receive(:new).with(collection_double, anything) {serialized_response}

      collection_double.stub(:save) {true}

      post :create, {collection: {name: 'foo', description: 'bar', thing: 'baz'}}, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns the errors" do
      Collection.should_receive(:new).with({"name" => 'foo', "description" => 'bar', "user" => user}) {collection_double}

      collection_double.stub(:save) {false}
      collection_double.stub(:errors) { {name: ['missing!']} }

      post :create, {collection: {name: 'foo', description: 'bar', thing: 'baz'}}, format: :json

      response.status.should == 422
      JSON.parse(response.body).should ==  { "collection" => {"name" => 'foo', "description" => 'bar'}, "errors" => {"name" => ["missing!"] } }
    end
  end

  describe "update" do
    it "fails when the collection is not found" do
      Collection.stub(:find) { nil }

      put :update, id: 1923, format: :json

      response.status.should == 404
    end

    it "returns the updated collection" do
      Collection.stub(:find).with("123") { collection_double }
      collection_double.should_receive(:update_attributes).with({'name' => 'foo'}) {true}

      Api::V1::CollectionSerializer.should_receive(:new).with(collection_double, anything) {serialized_response}

      put :update, id: 123, collection: {name: 'foo'}, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns the errors when current user does not own the collection"

    it "returns the errors" do
      Collection.stub(:find).with("123") { collection_double }
      collection_double.should_receive(:update_attributes).with({'name' => 'foo'}) {false}
      collection_double.stub(:errors) { {name: ['missing!']} }

      Api::V1::CollectionSerializer.should_receive(:new) do |arg1, arg2|
        arg1.should == collection_double
        arg2[:status].should == 422
        arg2[:meta].should == {:name => ["missing!"]}
        arg2[:meta_key].should == "errors"
        serialized_response
      end

      put :update, id: 123, collection: {name: 'foo'}, format: :json

      response.status.should == 422
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end
  end

  describe "destroy" do
    it "fails when the collection is not found" do
      Collection.stub(:find) { nil }

      delete :destroy, id: 1923, format: :json

      response.status.should == 404
    end

    it "deletes the record" do
      Api::V1::CollectionSerializer.should_receive(:new).with(collection_double, anything) {serialized_response}

      Collection.stub(:find).with("123") { collection_double }
      collection_double.stub(:destroy) {true}
      delete :destroy, id: 123, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns errors when the record cannot be deleted" do
      Collection.stub(:find).with("123") { collection_double }
      collection_double.stub(:destroy) {false}
      delete :destroy, id: 123, format: :json

      response.status.should == 422
    end
  end
end
