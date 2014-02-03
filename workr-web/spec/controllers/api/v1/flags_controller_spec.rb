require 'spec_helper'

describe Api::V1::FlagsController do
  let(:user) { Fabricate(:user) }
  let(:article) { Fabricate(:article) }

  before { login_user(user) }

  describe "create" do
    it "creates the viewed article and returns a 200" do
      flag_params = { article: article.id, reason: "got it" }

      post :create, flag: flag_params, format: :json

      user.reload.flags.count.should == 1

      flag = user.flags.first
      flag.reason.should == "got it"
      flag.article.should == article

      response.status.should == 200
    end
  end
end
