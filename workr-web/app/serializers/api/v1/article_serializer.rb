module Api
  module V1
    class ArticleSerializer < ActiveModel::Serializer
      embed :ids, include: true
      attributes :id, :title, :description,
        :tag_list, :clipped_name, :clipped_collection,
        :collections, :user, :collection,
        :is_file, :is_video, :is_image, :is_html, :content_source, 
        :average_rating, :rating,
        :is_editable, :view_count, :links

      def is_file
        object.class == FileArticle
      end


      def rating
        rating = ArticleManager.user_rating(object, current_user)
        if rating
          rating.id
        else
          nil
        end
      end

      def view_count
        object.views.count
      end


      def is_editable
        current_user.id == object.user.id
      end

      def is_html
        object.class == HtmlArticle
      end
      
      def is_video
        object.class == VideoArticle
      end

      def is_image
        object.class == ImageArticle
      end

      def clipped_name
        object.collections.empty? ?  nil : object.collections.first.user.full_name
      end

      def user
        object.collections.empty? ? nil : object.collections.first.user.id
      end

      def collection
        object.collections.empty? ? nil : object.collections.first.id
      end

      def collections
        object.collections.map(&:id)
      end

      def content_source
        object.content_source_id
      end
      
      def clipped_collection
        object.collections.empty? ? nil : object.collections.first.name
      end

      def links
        if object.new_record?
          {}
        else
          { related_articles: related_articles_api_article_path(object) }
        end
      end
    end
  end
end
