class ClipController < ApplicationController
  before_filter :store_location
  before_filter :authenticate_user!

  def create
    raise "No url defined" unless params[:url].present?

    content_source = Clipper::Importer.import_content_source(url: params[:url])

    if content_source.save
      redirect_to "/content_sources/#{content_source.id}/articles/new", status: :found
    else
      raise "could not clip"
    end
  end
end
