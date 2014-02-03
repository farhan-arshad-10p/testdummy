require 'spec_helper'

describe Api::V1::ContentSourcesController do
  let(:user) { Fabricate(:user) }
  let(:content_source) { Fabricate(:content_source) }
  let(:serialized_response) { double(as_json: {'foo' => 'bar'}) }
  before { login_user(user) }

  describe "create" do
    it "creates a content source and returns it" do
      content_source = double(save: true)
      Api::V1::ContentSourceSerializer.stub(:new) { serialized_response }
      Clipper::Importer.should_receive(:import_content_source).with(url: "http://www.cardz.com") { content_source }

      post :create, {content_source: {"url" => "http://www.cardz.com"}}, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "creates a hosted file and content source from the URL when given a file" do
      content_source = double(save: true)
      Api::V1::ContentSourceSerializer.stub(:new) { serialized_response }
      Clipper::Importer.should_receive(:import_content_source).with(file: "my_file") { content_source }

      post :create, {content_source: {"file" => "my_file"}}, format: :json

      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end

    it "returns a 422 and returns the broken content source" do
      content_source = double(save: false, errors: {url: ['funky']})
      Clipper::Importer.should_receive(:import_content_source).with(url: "http://www.cardz.com") { content_source }
      Api::V1::ContentSourceSerializer.stub(:new) do |arg1, arg2|
        arg1.should == content_source
        arg2[:status].should == 422
        arg2[:meta].should == {:url => ["funky"]}
        arg2[:meta_key].should == "errors"
        serialized_response 
      end

      post :create, {content_source: {"url" => "http://www.cardz.com"}}, format: :json

      response.status.should == 422
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end
  end

  describe "show" do
    it "serializes the collection" do
      Api::V1::ContentSourceSerializer.should_receive(:new).with(content_source, anything) { serialized_response}
      get :show, id: content_source.id, format: :json
      response.status.should == 200
      JSON.parse(response.body).should ==  {'foo' => 'bar'}
    end
  end
end
