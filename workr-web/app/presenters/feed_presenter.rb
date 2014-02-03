class FeedPresenter < Presenter
  attr_reader :total_pages, :next_page
  def initialize(source, extras={})
    super
    @total_pages = source.total_pages
    @next_page = source.next_page
  end

  def as_json(options=nil)
    is_search = extras[:query].present?
    content_type = extras[:content_type] || "all"

    articles = if is_search == false and (source.next_page == 2 or source.next_page.nil?)
                 [ArticleManager.recent_following(extras[:current_user], 21), source.to_a].flatten
               else
                 source
               end

    feed = {
      id: is_search ? "search:#{content_type}:#{extras[:keywords].parameterize}" : "feed",
      articles: articles.uniq,
      # TODO Look into https://github.com/emberjs/data/pull/1382 - thats the reason we uniq here
    }
  end
end
