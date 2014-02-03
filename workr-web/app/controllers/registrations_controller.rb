class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :check_invite_code
  before_action :check_user

  def new
    @user = User.new
    if params[:uid]
      @uid = params[:uid]
      @provider = "twitter"
    end

    @show_form = params[:email].present? || @uid.present?
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save!
      @invite.update_attributes!(active: false, user_id: @user.id)

      sign_in(:user, @user) 
      flash[:success] = t(".success")
      redirect_to root_path
    else 
      flash[:error] = t(".error")
      render "new"
    end
  end

  private
  def check_invite_code
    @invite = Invite.find_by_code(params[:invite_code])

    if @invite.nil?
      flash[:notice] = t(".missing_invite")
      redirect_to new_user_session_path
    elsif !@invite.active
      flash[:notice] = t(".used_invite")
      redirect_to new_user_session_path
    end
  end

  def check_user
    redirect_to(root_path) if current_user
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :email, :terms_of_service, :first_name, :last_name, :interest_ids, :uid, :provider)
  end

end
