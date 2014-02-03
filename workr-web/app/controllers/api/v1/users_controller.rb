module Api
  module V1
    class UsersController < Api::ApplicationController
      before_filter :find_user, only: [:show, :followers, :following]

      def index
        keywords = params[:query].present? ? [params[:query]] : current_user.interests.map(&:name)
        page = params[:page]
        results = UserManager.search_keywords(keywords, page)
        render json: results, each_serializer: UserSerializer, meta: {total_pages: results.total_pages, next_page: results.next_page}
      end

      def show
        render json: @user, serializer: UserSerializer
      end

      def update
        UserManager.update_following(current_user, params[:user][:following])
        if current_user.update_attributes(user_params)
          render json: current_user, serializer: UserSerializer
        else
          render json: current_user, serializer: UserSerializer, status: :unprocessable_entity, meta: current_user.errors, meta_key: 'errors'
        end
      end

      def followers
        render json: @user.followers, each_serializer: UserSerializer
      end

      def following
        render json: @user.following, each_serializer: UserSerializer
      end

      private
      def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
      end

      def find_user
        @user = User.find(params["id"])
        head 404 unless @user
      end
    end
  end
end
