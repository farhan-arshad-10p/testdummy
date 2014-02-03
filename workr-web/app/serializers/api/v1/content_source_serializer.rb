module Api
  module V1
    class ContentSourceSerializer < ActiveModel::Serializer
      embed :ids, include: true
      attributes :id, 
        :title, 
        :description,
        :content_body,
        :url, 
        :media_url, 
        :featured_image_url, 
        :provider_display, 
        :content_type

      def content_body
        object.content
      end
      
      def media_url
        object.media_url.gsub(/http:\/\//, '//') if object.media_url
      end
    end
  end
end
