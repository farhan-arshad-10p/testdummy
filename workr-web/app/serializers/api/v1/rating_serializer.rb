module Api
  module V1
    class RatingSerializer < ActiveModel::Serializer
      embed :ids
      attributes :id, :user, :article, :rating

      def article
        object.article.id
      end

      def user
        object.user.id
      end
    end
  end
end
