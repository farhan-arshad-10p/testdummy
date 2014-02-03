App.SearchPeopleRoute = Ember.Route.extend
  model: (params, queryParams) ->
    @controllerFor("application").set('searchSubject', 'users')
    try
      safe_query = decodeURIComponent(params.query)
    catch
      safe_query = params.query

    app_controller = @controllerFor("application")

    app_controller.set('search', safe_query)

    Analytics.searched(safe_query)

    @find_page(1)

  find_page: (page) ->
    page = 1 unless page
    query = @controllerFor("application").get('search')
    @store.find('user', {query: query, page: page})

  actions:
    willTransition: (transition) ->
      unless transition.targetName.indexOf("search") == 0
        @controllerFor("application").set('search', '')
        @controllerFor("application").set('searchType', 'all')
        @controllerFor("application").set('searchSubject', 'articles')

    showMore: (context) ->
      meta = @store.metadataFor("user")
      if meta.next_page
        Pace.options.ghostTime = 1000
        Pace.restart()
        @find_page(meta.next_page).then (users) =>
          model = @controller.get('model')
          model.addObjects users
