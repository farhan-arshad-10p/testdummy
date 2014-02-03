module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :first_name, :last_name, :email, :links, :avatar_url

      def avatar_url
        object.avatar.url
      end

      def links
        { 
          collections: api_user_collections_path(object),
          viewed_articles: api_user_viewed_articles_path(object),
          interests: api_user_interests_path(object),
          followers: followers_api_user_path(object),
          following: following_api_user_path(object),
        }
      end
    end
  end
end
