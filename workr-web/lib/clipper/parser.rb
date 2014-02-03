module Clipper
  class Parser
    NOTE_SELECTOR = "note"
    SOURCE_URL_SELECTOR = "note-attributes source-url"
    TAG_SELECTOR = "tag"
    VIDEO_ARTICLE_PROVIDERS = ["http://www.youtube.com/", "http://www.vimeo.com/"]
    SUPPORTED_FILE_EXTENTIONS = ["doc", "docx", "pdf", "ppt", "pptx", "xlsx", "xls"]
    EMBEDLY_TYPES = {html: "html", text: "html", image: "image", video: "video", audio: "html", ppt: "file", rss: nil, xml: nil, atom: nil, json: nil, link: nil }

    def self.parse_evernote(data, collection_name="", logger=nil)
      Nokogiri::XML(data).css(NOTE_SELECTOR).inject(Array.new) do |parsed_data, node| 
        if node.css(SOURCE_URL_SELECTOR).first
          parsed_data << { url: node.css(SOURCE_URL_SELECTOR).first.content, tags: node.css(TAG_SELECTOR).map(&:content) } 
        else
          logger.info("Skipped non-url entry in collection [#{collection_name}] - Could be embedded file") if logger
          parsed_data
        end
      end
    end

    def self.parse_embedly(data)
      media_url = data[:media]['html']
      featured_image = data[:images].empty? ? nil : data[:images].first['url']
      content_type = parse_url_type(data[:url], data[:provider_url], data[:type], data[:content], featured_image, media_url) 

      {
        content_type: content_type,
        url: data[:url],
        provider_url: data[:provider_url],
        provider_name: data[:provider_name],
        provider_display: data[:provider_display],
        title: data[:title],
        description: data[:description],
        content: data[:content],
        raw_article: data.to_json,
        featured_image_url: featured_image,
        media_url: media_url
      }
    end

    def self.parse_url_type(url, provider_url, type, content, featured_image, media_url)
      return "video" if VIDEO_ARTICLE_PROVIDERS.include?(provider_url)
      article_type = EMBEDLY_TYPES[type.to_sym] if type && EMBEDLY_TYPES.keys.include?(type.to_sym)
      if article_type == "html" && content.blank? && featured_image.present? && media_url.blank?
        return "image"
      elsif article_type.present?
        return article_type
      end

      fragment = URI.split(url)[5]
      match = fragment.match(/\.([\w+-]+)$/)
      "file" if match && SUPPORTED_FILE_EXTENTIONS.include?(match[1])
    end
  end
end
