App.ContentSourcesNewView = Ember.View.extend
  didInsertElement: ->
    $('.app-content-source-file').fileupload(
      dataType: 'json'
      url: '/api/content_sources'
      start: =>
        Pace.options.ghostTime = 3000
        Pace.restart()
      stop: =>
        Pace.stop()
      done: (e, data) =>
        @controller.transitionToRoute('articles.new', data.result.content_source.id)
    )
