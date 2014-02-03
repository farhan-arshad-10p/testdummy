module Api
  module V1
    class InterestsController < Api::ApplicationController
      def index
        render json: current_user.interests, each_serializer: InterestSerializer
      end
    end
  end
end
