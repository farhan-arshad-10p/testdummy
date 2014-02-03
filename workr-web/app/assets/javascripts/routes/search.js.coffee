App.SearchRoute = Ember.Route.extend
  model: (params, queryParams) ->
    try
      safe_query = decodeURIComponent(params.query)
    catch
      safe_query = params.query

    app_controller = @controllerFor("application")

    sType = if queryParams.type then queryParams.type else 'all'
    app_controller.set('search', safe_query)
    app_controller.set('searchType', sType)

    Analytics.searched(safe_query)

    app_controller.addObserver('isArticleListView', =>
      @find_page(1).then (arts) =>
        @controller.set('model', arts)
    )

    @find_page(1)

  find_page: (page) ->
    page = 1 unless page
    query = @controllerFor("application").get('search')
    contentType = @controllerFor("application").get('searchType')
    @store.find('feed', {query: query, contentType: contentType, page: page}).then (feed) ->
      feed.content[0].get('articles').then (arts) ->
        arts.toArray()

  actions:
    willTransition: (transition) ->
      unless transition.targetName.indexOf("search") == 0
        @controllerFor("application").set('search', '')
        @controllerFor("application").set('searchType', 'all')
        @controllerFor("application").set('searchSubject', 'articles')

    showMore: (context) ->
      meta = @store.metadataFor("feed")
      if meta.next_page
        Pace.options.ghostTime = 1000
        Pace.restart()
        @find_page(meta.next_page).then (arts) =>
          model = @controller.get('model')
          model.addObjects arts
