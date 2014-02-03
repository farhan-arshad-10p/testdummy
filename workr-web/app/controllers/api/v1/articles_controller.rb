module Api
  module V1
    class ArticlesController < Api::ApplicationController
      before_filter :find_article, only: [:destroy, :show, :update, :related_articles]

      def index
        load_associations = [:user, :collections, :content_source, :tags]
        preload_article = Article.includes(load_associations)
        articles = if params["ids"]
          preload_article.where(["id in (?)", params["ids"]])
        elsif params["collection_id"]
          Collection.find(params["collection_id"]).articles.includes(load_associations)
        else
          preload_article.limit(100)
        end
        render json: articles, each_serializer: ArticleSerializer
      end

      def show
        render json: @article, serializer: ArticleSerializer
      end

      def create
        content_source = ContentSource.find(params["article"]["content_source_id"])
        article = ArticleManager.create_from_content_source(content_source, article_params.merge(user_id: current_user.id, collection_ids: params["article"]["collection"]))

        if article.valid?
          render json: article, serializer: ArticleSerializer
        else
          render json: article, serializer: ArticleSerializer, status: :unprocessable_entity, meta: article.errors, meta_key: 'errors'
        end
      end

      def update
        if @article.update_attributes(article_params)
          render json: @article, serializer: ArticleSerializer
        else
          render json: @article, serializer: ArticleSerializer, status: :unprocessable_entity, meta: @article.errors, meta_key: 'errors'
        end
      end

      def destroy
        if @article.destroy
          render json: @article, serializer: ArticleSerializer
        else
          head :unprocessable_entity
        end
      end

      def related_articles
        render json: ArticleManager.related_articles(@article, 3), each_serializer: ArticleSerializer
      end

      private
       def article_params
         params.require(:article).permit(:title, :description, :tag_list)
       end

       def content_source_params
         params.require(:article).permit(:url, :tag_list)
       end

      def find_article
        @article = Article.find(params["id"])
        head :not_found unless @article
      end
    end
  end
end
