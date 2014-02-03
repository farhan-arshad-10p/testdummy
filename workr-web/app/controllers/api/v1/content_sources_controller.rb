module Api
  module V1
    class ContentSourcesController < Api::ApplicationController
      def show
        content_source = ContentSource.find(params["id"])
        render json: content_source, serializer: ContentSourceSerializer
      end

      def create
        if content_source_params["file"].present?
          content_source = Clipper::Importer.import_content_source(file: content_source_params["file"])
        else
          content_source = Clipper::Importer.import_content_source(url: content_source_params["url"])
        end

        if content_source.save
          render json: content_source, serializer: ContentSourceSerializer
        else
          render json: content_source, serializer: ContentSourceSerializer, status: 422, meta: content_source.errors, meta_key: 'errors'
        end
      end

      private
      def content_source_params
        params.require(:content_source).permit(:url, :file)
      end
    end
  end
end
