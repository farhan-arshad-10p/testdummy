require 'spec_helper'

describe Api::V1::FeedsController do
  let(:user) { Fabricate(:user) }
  let(:serialized_response) { double(as_json: {'foo' => 'bar'}) }
  before { login_user(user) }
  let(:results) { double(total_pages: 5, next_page: 2) }
  let(:presented_results) { double(total_pages: 99, next_page: 5, as_json: :results) }

  describe "#new" do
    describe "without query params" do
      let(:args) { {"contentType" => "all"} }
      let(:interests) { [double(name: "Dogs"), double(name: "Cats")] }

      it "assigns articles" do
        user.stub(:interests) { interests }
        ArticleManager.stub(:search_keywords).with(["Dogs", "Cats"], nil, "all") { results }
        FeedPresenter.should_receive(:present).with([results], {query: nil, keywords: "Dogs Cats", current_user: user, content_type: "all"}) {[presented_results]}
        Api::V1::FeedSerializer.should_receive(:new).with(presented_results.as_json, anything) { serialized_response }
        get :index, args
        response.status.should == 200
        response.body.should_not be_blank
        JSON.parse(response.body).should == {"feeds" => [{ 'foo' => 'bar' }], "meta" => {"total_pages" => 99, "next_page" => 5}}
      end
    end

    describe "with query params" do
      let(:args) { {"query" => "Dogs", "contentType" => "images", "page" => 99} }

      it "assigns articles" do
        ArticleManager.stub(:search_keywords).with(["Dogs"], "99", "images") { results }
        FeedPresenter.should_receive(:present).with([results], {query: "Dogs", keywords: "Dogs", current_user: user, content_type: "images"}) {[presented_results]}
        Api::V1::FeedSerializer.should_receive(:new).with(presented_results.as_json, anything) { serialized_response }
        get :index, args
        response.status.should == 200
        response.body.should_not be_blank
        JSON.parse(response.body).should == {"feeds" => [{ 'foo' => 'bar' }], "meta" => {"total_pages" => 99, "next_page" => 5}}
      end
    end
  end
end
