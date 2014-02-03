module Api
  module V1
    require 'ostruct'
    class FeedsController < Api::ApplicationController
      def index
        keywords = params[:query].present? ? [params[:query]] : current_user.interests.map(&:name)
        page = params[:page]
        content_type = params[:contentType]
        results = ArticleManager.search_keywords(keywords, page, content_type)
        presented_feed = FeedPresenter.present([results], {query: params[:query], keywords: keywords.join(' '), current_user: current_user, content_type: content_type}).first 
        render json: [presented_feed.as_json], each_serializer: FeedSerializer, meta: {total_pages: presented_feed.total_pages, next_page: presented_feed.next_page, last_path: get_cookie_path}
      end
      include ActionController::Cookies

      def set_path
        cookies[:last_path] = params[:path]
        render :json => ({:path => cookies[:last_path]})
      end

      def get_path
        cookies[:last_path] = (cookies[:last_path]) ? cookies[:last_path] : 'feeds'
        render :json => ({:path => cookies[:last_path]})
      end

      private
        def get_cookie_path
          cookies[:last_path]
        end
    end
  end
end
