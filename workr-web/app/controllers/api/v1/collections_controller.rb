module Api
  module V1
    class CollectionsController < Api::ApplicationController
      before_filter :find_collection, only: [:destroy, :show, :update]
      def index
        collection_includes = Collection.includes(:user)
        collections = if !params["ids"].nil?
          collection_includes.where(["id in (?)", params["ids"]])
        elsif params["user_id"]
          collection_includes.where(user_id: params["user_id"])
        else
          collection_includes.limit(100)
        end
        render json: collections, each_serializer: CollectionSerializer
      end

      def show
        render json: @collection, serializer: CollectionSerializer
      end

      def update
        if @collection.update_attributes(collection_params)
          render json: @collection, serializer: CollectionSerializer
        else
          render json: @collection, serializer: CollectionSerializer, status: :unprocessable_entity, meta: @collection.errors, meta_key: 'errors'
        end
      end

      def create
        collection = Collection.new(collection_params.merge(user: current_user))
        if collection.save
          render json: collection, serializer: CollectionSerializer
        else
          render json: {collection: collection_params, errors: collection.errors}, status: :unprocessable_entity
        end
      end

      def destroy
        if @collection.destroy
          render json: @collection, serializer: CollectionSerializer
        else
          head :unprocessable_entity
        end
      end

      private
      def collection_params
        params.require(:collection).permit(:name, :description)
      end

      def find_collection
        @collection = Collection.find(params["id"])
        head :not_found unless @collection
      end
    end
  end
end
