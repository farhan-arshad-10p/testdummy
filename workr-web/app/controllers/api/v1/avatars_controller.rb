module Api
  module V1
    class AvatarsController < Api::ApplicationController
      def create
        if current_user.update_attributes(user_params)
          render json: current_user, serializer: UserSerializer
        else
          render json: current_user, serializer: UserSerializer, status: 422, meta: current_user.errors, meta_key: 'errors'
        end
      end

      private
      def user_params
        params.require(:user).permit(:avatar)
      end
    end
  end
end
