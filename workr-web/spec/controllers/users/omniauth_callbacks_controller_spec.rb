require 'spec_helper'

describe Users::OmniauthCallbacksController do
  describe "#twitter" do
    let(:found_user) { Fabricate(:user) }

    it "when the user is found" do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = {"uid" => "10"}
      
      User.should_receive(:find_for_authentication).with(uid: "10", provider: "twitter") { found_user }
      get :twitter
      response.should be_redirect
      response.should redirect_to(root_path)
    end

    describe "when the user is not found" do
      before do
        User.stub(:find_for_authentication) { nil }
      end

      it "should redirect to the registrations controller with the invite_code set and uid set" do
        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = {"uid" => "10"}
        get :twitter, {invite_code: "abc123"}
        response.should be_redirect
        response.should redirect_to(new_user_registration_path(invite_code: "abc123", uid: "10") )
      end

      it "should redirect to the signin when the invite is not set" do
        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env["omniauth.auth"] = {"uid" => "10"}
        get :twitter
        response.should be_redirect
        flash[:notice].should be
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end
