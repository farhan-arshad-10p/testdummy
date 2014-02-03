module Api
  module V1
    class ViewedArticleSerializer < ActiveModel::Serializer
      attributes :id, :article, :user

      def article
        object.article_id
      end

      def user
        object.user_id
      end
    end
  end
end
