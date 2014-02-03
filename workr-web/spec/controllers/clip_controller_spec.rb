require 'spec_helper'

describe ClipController do
  let(:user) { Fabricate(:user) }
  before { login_user(user) }

  describe "#create" do

    describe "when we can import the source" do
      let(:args) { { url: "http://www.google.com" } }
      let(:source) { double(id: 1, save: true) }

      it "redirects to the content_source articles new" do
        Clipper::Importer.should_receive(:import_content_source).with(url: "http://www.google.com") { source } 

        post :create, args

        response.should be_redirect
        response.should redirect_to("/content_sources/1/articles/new")
      end
    end
  end
end
