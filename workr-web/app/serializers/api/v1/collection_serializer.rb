module Api
  module V1
    class CollectionSerializer < ActiveModel::Serializer
      attributes :id, :name, :description, :user, :teaser_image, :article_count, :is_editable, :links

      def user
        object.user_id
      end

      def is_editable
        current_user.id == object.user.id
      end

      def article_count
        object.articles.count
      end

      def teaser_image
        object.articles.includes(:content_source).map(&:content_source).map(&:featured_image_url).compact.last
      end

      def links
        {
          articles: api_collection_articles_path(object)
        }
      end
    end
  end
end
