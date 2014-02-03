App.ApplicationRoute = Ember.Route.extend Ember.TargetActionSupport,
  renderTemplate: ->
    in_frame = window.location != window.parent.location
    @controller.set('inFrame', in_frame)
    if in_frame
      @render('application_minimal')
    else
      @render('application')

  actions:
    searchUsers: ->
      @controller.set('searchSubject', 'users')
      @transitionTo('searchPeople', @controller.get('search'))
    searchArticles: ->
      @controller.set('searchSubject', 'articles')
      if !!@controller.get('search')
        @transitionTo('search', @controller.get('search'))
      else
        @transitionTo('feeds')
    searchCollections: ->
      @controller.set('searchSubject', 'collections')
      if !!@controller.get('search')
        @transitionTo('search', @controller.get('search'))
      else
        @transitionTo('feeds')

    willTransition: (transition) ->
      @triggerAction(action: 'closeModal', target: @)

    saveArticle: (article) ->
      @triggerAction(action: 'closeModal', target: @)
      @controller.transitionToRoute('articles.new', article.get('content_source'))

    flagArticle: (article, reason) ->
      flag = @store.createRecord('flag', article: article, reason: reason)
      flag.save()
      alert("#{article.get('title')} has been flagged for #{reason}.")

    openModal: (article, related_article_parent) ->
      @controller.viewArticle(article)
      Analytics.viewed_article(article)
      Analytics.viewed_related_article(article, related_article_parent) if related_article_parent
      $('body').addClass('modal-open')

    closeModal: ->
      $('body').removeClass('modal-open')
      @controller.set('modalModel', null)

    query: ->
      query = @controller.get('search')
      if @controller.get('isUserSearch')
        @triggerAction(action: 'searchUsers', target: @)
      else if @controller.get('isArticleSearch')
        @triggerAction(action: 'searchArticles', target: @)
      else if @controller.get('isCollectionSearch')
        @triggerAction(action: 'searchCollections', target: @)

    editCollection: (collection) ->
      @controller.transitionToRoute 'collections.edit', collection

    setArticleListView: (state) ->
      Pace.options.ghostTime = 1000
      Pace.restart()
      @controller.set('model', [])
      @controller.set('articleListView', state)
