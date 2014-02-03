App.FeedsRoute = Ember.Route.extend
  model: ->
    app_controller = @controllerFor("application")
    app_controller.addObserver('isArticleSearch', =>
      @find_page(1).then (arts) =>
        @controller.set('model', arts)
    )
    @find_page(1)

  find_page: (page) ->
    page = 1 unless page
    @store.find('feed', page: page).then (feed) ->
      window.food = feed
      feed.content[0].get('articles').then (arts) ->
        arts.toArray()
  
  hasMore: false

  actions:
    showMore: (context) ->
      meta = @store.metadataFor("feed")
      if meta.next_page
        Pace.options.ghostTime = 1000
        Pace.restart()
        @find_page(meta.next_page).then (arts) =>
          model = @controller.get('model')
          model.addObjects arts
