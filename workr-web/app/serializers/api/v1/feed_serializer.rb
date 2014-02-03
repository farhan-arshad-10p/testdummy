module Api
  module V1
    class FeedSerializer < ActiveModel::Serializer
      attributes :id, :articles, :title

      def id
        object[:id]
      end

      def articles
        object[:articles].map(&:id)
      end

      def title
        object[:id]
      end
    end
  end
end
