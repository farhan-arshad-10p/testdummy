class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    uid = request.env['omniauth.auth']["uid"] 
    user = User.find_for_authentication(uid: uid, provider: "twitter")

    sign_in_and_redirect(user, :event => :authentication) and return if user

    if params["invite_code"]
      redirect_to new_user_registration_path(invite_code: params[:invite_code], uid: uid) and return
    else
      redirect_to(new_user_session_path, notice: "Could not authenticate.") and return
    end
  end
end
