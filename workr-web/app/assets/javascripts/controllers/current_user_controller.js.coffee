App.CurrentUserController = Ember.ObjectController.extend
  articles: []
  isSignedIn: (->
    @get('content') != null
  ).property('@content')

  viewArticle: (article) ->
    @get('viewed_articles').content.createRecord(article: article).save()

  followUser: (user) ->
    user_following = @get('following')
    if user_following.then
      user_following.then (following) =>
        @_addFollow(user, following)
    else
      @_addFollow(user, user_following)

  _addFollow: (user, following) ->
    following.addObject(user)
    @content.then (current_user) =>
      current_user.save()

  unfollowUser: (user) ->
    user_following = @get('following')
    if user_following.then
      user_following.then (following) =>
        @_removeFollow(user, following)
    else
      @_removeFollow(user, user_following)
        
  _removeFollow: (user, following) ->
    following.removeObject(user)
    @content.then (current_user) =>
      current_user.save()

  rateArticle: (article, rating) ->
    userRating = article.get('userRating')
    unless userRating
      userRating = article.get('viewed_articles').content.createRecord()

    userRating.set('rating', rating)
    userRating.save()

  viewedArticles: (->
    articles = @get('content').get('viewed_articles').map((va) -> va.get('article')).reverse()
    articles[0..4]
  ).property('content.viewed_articles.@each')

  rateArticle: (article, rating) ->
    user_rating = article.get('user_rating')
    if user_rating
      user_rating.set('rating', rating)
    else
      user_rating = @store.createRecord('rating', {article: article, user: @get('content'), rating: rating})
    user_rating.save()
