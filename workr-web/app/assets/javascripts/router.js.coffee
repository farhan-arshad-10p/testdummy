App.Router.reopen
  location: 'history'

App.Router.map ->
  @route('about')
  @route('clipper')
  @route('viewed_articles')
  @resource('user', path: "/user/:user_id", ->
    @route('index', path: "/")
    @route('collections', path: "/collections")
    @route('following', path: "/following")
  )


  @route('settings', path: "/settings")
  @route('settings.avatar', path: "/settings/avatar")
  @route('settings.following', path: "/settings/following")
  @route('settings.collections', path: "/settings/collections")

  @resource('collections', ->
    @route('new')
    @route("edit", { path: ":collection_id/edit" })
    @route("show", { path: ":collection_id" })
  )

  @resource('feeds', path: "/")
  @route('searchPeople', path: "/search/people/:query")
  @route('search', path: "/search/:query", queryParams: ["type"])


  @resource('content_sources', ->
    @route("new")

    @resource('articles', { path: "/:content_source_id/articles" }, ->
      @route("new")
    )
  )


  @resource('articles', ->
    @route("edit", { path: ":article_id/edit" })
    @route("show", { path: ":article_id" })
  )

  @route('four_oh_four', {path: "*path"})
