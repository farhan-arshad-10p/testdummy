App.User = DS.Model.extend
  first_name: DS.attr 'string'
  last_name: DS.attr 'string'
  email: DS.attr 'string'
  avatar_url: DS.attr 'string'
  current_user: DS.attr 'boolean'
  collections: DS.hasMany('collection', async: true)
  viewed_articles: DS.hasMany('viewed_article', async: true)
  interests: DS.hasMany('interest', async: true)
  followers: DS.hasMany('user', async: true, inverse: 'following')
  following: DS.hasMany('user', async: true, inverse: 'followers')

  follower_count: ( -> @get('followers.length') ).property('followers.length')
  following_count: ( -> @get('following.length') ).property('following.length')
  collection_count: ( -> @get('collections.length') ).property('collections.length')

  full_name: (->
    "#{@get('first_name')} #{@get('last_name')}"
  ).property('first_name', 'last_name')

  appClass: (->
    "app-user-#{@get('id')}"
  ).property('id')

  recentlyViewedArticles: (->
    articles = @get('viewed_articles').map (va) -> va.get('article')
    articles.reverse()
  ).property('viewed_articles')

  sortedCollections: (->
    Ember.ArrayController.create
      content: @get('collections').toArray()
      sortProperties: ["name"]
  ).property('collections.@each.isLoaded')
