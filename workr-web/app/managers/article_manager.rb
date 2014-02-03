class ArticleManager
  RATING_THRESHOLD = 10
  CONTENT_TYPES = {
    all: Article,
    text: HtmlArticle,
    image: ImageArticle,
    video: VideoArticle,
    file: FileArticle,
  }

  def self.create(args)
    Article.create(
      content_source_id: args[:content_source_id],
      user_id: args[:user_id],
      type: args[:type],
      title: args[:title],
      description: args[:description],
      collection_ids: args[:collection_ids],
    )
  end

  def self.create_from_content_source(content_source, args, filler_desc=nil)
    args[:type] = "#{content_source.content_type.titleize}Article" if content_source.content_type
    args[:content_source] = content_source
    args[:title] = content_source.title unless args[:title].present?
    # args[:description] = content_source.description unless args[:description].present?
    args[:description] = args[:description] || content_source.description || filler_desc

    Article.create(args)
  end

  def self.add_article_to_collection!(article, collection_id)
    collection = Collection.find(collection_id)
    collection.articles << article unless collection.articles.include?(article)
  end

  def self.related_articles(article, count)
    related = Sunspot.more_like_this(article) do
      fields :title, :content
    end.results

    related.take(count)
  end

  def self.search_keyword(keyword, *args)
    search_keywords keyword, *args
  end

  def self.search_keywords(keywords, *args)
    page = args[0] || 1
    content_type = args[1] || 'all'
    
    search_terms = String.try_convert(keywords) ? keywords : keywords.join(' ')
    workr_settings = WorkrSettings.all.reload.first 
    article_clazz = CONTENT_TYPES[content_type.parameterize.underscore.to_sym] or Article
    articles = article_clazz.solr_search do 
      paginate page: page, per_page: 51
      fulltext(search_terms) {
        minimum_match 1
        eval(workr_settings.article_search_settings) unless workr_settings.nil?
      }
      order_by :score, :desc
      order_by :average_rating, :desc
    end.results
  end

  def self.increment_view_count(article)
    article.increment! :view_count
  end

  def self.user_rating(article, user)
    article.ratings.where(user: user).first
  end

  def self.recent_following(user, count=3)
    articles = []

    user.following.each do |followed|
      articles << followed.articles.take(count)
    end

    articles = articles.flatten.sort { |x, y| y.created_at <=> x.created_at }

    articles.take(count)
  end
end
