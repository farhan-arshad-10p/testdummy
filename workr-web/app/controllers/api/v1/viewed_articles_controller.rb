module Api
  module V1
    class ViewedArticlesController < Api::ApplicationController
      def create
        viewed_article = current_user.viewed_articles.create!(article_id: viewed_article_params()[:article])
        render nothing: true, status: :ok
      end

      def index
        render json: current_user.viewed_articles.limit(5), each_serializer: ViewedArticleSerializer
      end


      private
       def viewed_article_params
         params.require(:viewed_article).permit(:article)
       end
    end
  end
end
