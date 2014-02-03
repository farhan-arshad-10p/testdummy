class Update < Thor
  require File.join(File.dirname(__FILE__), *%w[.. config environment])
  require File.join(File.dirname(__FILE__), 'thor_helpers')
  include ThorHelpers

  desc "by_article", "Updates content source and associated articles with the given article id"
  def by_article(article_id)
    article = Article.find_by_id(article_id)
    if article
      content_source = article.content_source
      extracted_page = PageExtractor.extract(content_source.url)
      content_args = Clipper::Parser.parse_embedly(extracted_page)
      content_source.update_attributes(content_args)
      content_source.save
      articles = Article.where(content_source_id: content_source.id)
      articles.each do |assc_article|
        assc_article.type =  "#{content_source.content_type.titleize}Article" if content_source.content_type
      end
    end
  end

  desc "empty_html", "Updates html content sources that have no content"
  def empty_html
    bar ||= ProgressBar.new(0)
    empty_html_content = ContentSource.where(content_type: 'html', content: nil)
    bar.max += empty_html_content.count
    empty_html_content.each do |content_source|
      bar.increment!
      extracted_page = PageExtractor.extract(content_source.url)
      content_args = Clipper::Parser.parse_embedly(extracted_page)
      content_source.update_attributes(content_args)
      content_source.save
      bar.increment!

      articles = Article.where(content_source_id: content_source.id)
      bar.max += articles.count
      articles.each do |assc_article|
        assc_article.type =  "#{content_source.content_type.titleize}Article" if content_source.content_type
        bar.increment!
      end
    end
  end
end
