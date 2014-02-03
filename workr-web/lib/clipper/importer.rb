module Clipper
  class Importer
    def self.import_content_source(params)
      if params[:file]
        hosted_file = HostedFile.create!(upload: params[:file])
        return ContentSourceManager.new_content_source(url: hosted_file.upload.url, content_type: "file")
      end

      url = params[:url]
      return @content_source if @content_source = ContentSource.find_by_url(url)
      extracted_page = PageExtractor.extract(url)
      content_args = Clipper::Parser.parse_embedly(extracted_page)
      return @content_source if @content_source = ContentSource.find_by_url(content_args[:url])
      ContentSourceManager.new_content_source(content_args)
    end

    def self.create_from_content_source_in_collection(content_source, collection, article_args, filler_desc=nil)
      user_id = collection.user_id
      article = Article.find_by(content_source_id: content_source.id, user_id: user_id)

      if article
        ArticleManager.add_article_to_collection!(article, collection.id)
      else
        article_args[:user_id] = user_id
        article_args[:collection_ids] = [collection.id]
        article = ArticleManager.create_from_content_source(content_source, article_args, filler_desc)
      end
    end
  end
end
