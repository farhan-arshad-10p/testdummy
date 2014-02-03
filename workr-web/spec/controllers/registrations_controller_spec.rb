require 'spec_helper'

describe RegistrationsController do
  describe "#create" do
    let(:args) { 
      { 
        user: {
          "email" => "admin@example.com", 
          "password" => "password", 
          "password_confirmation" => "password",
          "first_name" => "Chuck",
          "last_name" => "Tehcode",
          "uid" => "12345",
          "provider" => "Facespace",
          "interest_ids" => "foo, bar",
          "terms_of_service" => true,
          "mac_version" => "Maaahvericks",
        }, 
        invitation_code: "abc123" 
      }
    }

    describe "with a bad invite" do
      it "redirects when there is no invite in the system" do
        Invite.stub(:find_by_code) { nil }
        post :create, args

        flash[:notice].should be
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end

      it "redirects when the invite is inactive" do
        Invite.stub(:find_by_code) { double(active: false) }
        post :create, args
        flash[:notice].should be
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "with a valid user" do
      let(:user) { double(:valid? => true, :save! => true, id: 10000) } 
      let(:invite) { double(:update_attributes! => true, active: true) } 

      before do
        Invite.stub(:find_by_code) { invite } 
        User.stub(:new) { user }
        subject.stub(:sign_in)
      end

      it "should create a new user" do
        user_params = {
          "email" => "admin@example.com", 
          "password" => "password", 
          "password_confirmation" => "password",
          "first_name" => "Chuck",
          "last_name" => "Tehcode",
          "uid" => "12345",
          "provider" => "Facespace",
          "interest_ids" => "foo, bar",
          "terms_of_service" => true,
        }
        User.should_receive(:new).with(user_params) { user }
        user.should_receive(:save!)
        post :create, args
      end

      it "should consume the invite" do
        user.stub(:id) { 1000 }
        invite.should_receive(:update_attributes!).with(active: false, user_id: 1000)
        post :create, args
      end

      it "should redirect to the root" do 
        post :create, args
        response.should be_redirect
        response.should redirect_to(root_path)
      end

      it "should set the flash and sign in the user" do 
        subject.should_receive(:sign_in).with(:user, user)
        post :create, args
        flash[:success].should be 
      end
    end


    describe "with an invalid user" do
      let(:user) { double(:valid? => false) }

      it "renders new" do
        Invite.stub(:find_by_code) { double(active: true) }
        User.stub(:new) { user }
        
        post :create, args

        flash[:error].should be 
        response.should be_success
        response.should render_template(:new)
      end
    end
  end

  describe "#new" do
    let(:args) { { invitation_code: "abc123" } }
    let(:user) { double('user') }
    let!(:created_user) { Fabricate(:user) }

    before do
      User.stub(:new) { user } 
      Invite.stub(:find_by_code) { invite }
    end

    describe "with a code" do

      let(:invite) { double(active: true) } 

      it "should assign a new user" do
        my_user = double
        User.should_receive(:new) { my_user } 
        get 'new', args
        assigns(:user).should == my_user
        assigns(:invite).should == invite
      end

      it "should render the new page" do
        get 'new', args
        response.should be_success
        response.should render_template(:new)
      end

      it "should assign the twitter uid and the show_form from params" do
        get 'new', args.merge(uid: "abc123")
        assigns(:uid).should == "abc123"
        assigns(:provider).should == "twitter"
        assigns(:show_form).should be_true
      end

      it "should redirect the user if they are signed in" do
        login_user(created_user)

        User.should_not_receive(:new)
        get 'new', args

        response.should redirect_to(root_path)
      end
    end

    describe "without a code" do
      let(:invite) { nil }

      it "should redirect assign a new user" do
        get 'new', {}
        response.should redirect_to new_user_session_path
      end
    end
  end
end
