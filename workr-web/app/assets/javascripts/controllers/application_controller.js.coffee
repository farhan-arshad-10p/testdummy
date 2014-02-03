window.page_loaded_from_server = true
App.ApplicationController = Ember.Controller.extend
  needs: ['currentUser']

  search: ''
  isArticleSearch: (-> @get('searchSubject') == 'articles').property('searchSubject')
  isCollectionSearch: (-> @get('searchSubject') == 'collections').property('searchSubject')
  isUserSearch: (-> @get('searchSubject') == 'users').property('searchSubject')

  VALID_SEARCH_TYPES: ['all', 'text', 'image', 'video', 'file']
  _searchType: 'all'
  searchType: ((key, value) ->
    if arguments.length > 1
      sType = if @get('VALID_SEARCH_TYPES').contains(value)
                value
              else
                'all'
      @set('_searchType', sType)
    @get('_searchType')
  ).property('_searchType')

  VALID_SEARCH_SUBJECTS: ['articles', 'collections', 'users']
  _searchSubject: 'articles'
  searchSubject: ((key, value) ->
    if arguments.length > 1
      sSubject = if @get('VALID_SEARCH_SUBJECTS').contains(value)
                value
              else
                'articles'
      @set('_searchSubject', sSubject)
    @get('_searchSubject')
  ).property('_searchSubject')

  inFrame: false

  modalModel: null

  viewArticle: (article) ->
    @get('controllers.currentUser').viewArticle(article)
    @set('modalModel', article)

  trackPageView: (->
    that = this
    Ember.run.next ->
      loc = window.location
      page = (if loc.hash then loc.hash.substring(1) else loc.pathname + loc.search)

      if window.page_loaded_from_server == true
        jQuery.ajax "/api/get_path/",
          type: "GET"
          success: ( (response) ->
            console.log response.path
            last_path = response.path
            that.transitionTo(last_path)

          )
      window.page_loaded_from_server = false
      jQuery.ajax "/api/set_path/",
        type: "POST"
        data: 'path=' + page

      Analytics.page_change(page)
  ).observes("currentPath")
