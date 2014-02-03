class UserManager
  def self.update_following(user, following)
    following ||= []
    following.map!(&:to_i)
    current_follows = user.following.map(&:id)
    to_add = following - current_follows
    to_remove = current_follows - following

    to_add.each do |following_id|
      Relationship.find_or_create_by(follower: user, followed_id: following_id).save()
    end

    to_remove.each do |following_id|
      Relationship.find_by(follower: user, followed_id: following_id).destroy
    end
  end

  def self.search_keywords(keywords, *args)
    page = args[0] || 1
    search_terms = String.try_convert(keywords) ? keywords : keywords.join(' ')
    User.solr_search do 
      paginate page: page, per_page: 50
      fulltext(search_terms) {
        minimum_match 1
      }
    end.results
  end
end
