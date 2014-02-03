class RatingsManager
  def self.create_or_update(args)
    rating = Rating.find_or_create_by(article_id: args[:article_id], user_id: args[:user_id])
    rating.rating = args[:rating]
    rating.save

    article = Article.find args[:article_id]
    Sunspot.index article
    Sunspot.commit
  end
end
