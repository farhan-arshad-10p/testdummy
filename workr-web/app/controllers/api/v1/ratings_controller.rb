module Api
  module V1
    class RatingsController < Api::ApplicationController
      def create
        RatingsManager.create_or_update(article_id: rating_params()[:article], user_id: current_user.id, rating: rating_params()[:rating])
        render nothing: true, status: :ok
      end

      def show
        rating = Rating.find(params[:id])
        render json: rating, serializer: RatingSerializer
      end

      private
      def rating_params
        params.require(:rating).permit(:article, :rating)
      end
    end
  end
end
