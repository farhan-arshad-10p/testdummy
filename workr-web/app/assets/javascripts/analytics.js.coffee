( ->
  google_track_page = (url) ->
    if window._gaq
      event = ['_trackPageview']
      event.push url if url
      _gaq.push(event)

  kiss_track_event = (name, data) ->
    if window._kmq
      event = ['record', name]
      event.push data if data
      _kmq.push(event)

  window.Analytics =
    page_change: (url) ->
      google_track_page()

    clipped_url: (url) ->
      kiss_track_event("Clipped URL", {'URL': url})

    created_article: (model) ->
      data =
        'Title': model.get('title')
        'URL': model.get('content_source').get('url')
        'Collection Name': model.get('clipped_collection')

      kiss_track_event("Save Article", data)

    created_collection: (model) ->
      data =
        'Title': model.get('name')
        'Collection ID': model.get('id')

      kiss_track_event("Create Collection", data)

    searched: (terms) ->
      # No event tracking right now

    viewed_article: (model) ->
      data =
        'Title': model.get('title')
        'URL': model.get('content_source').get('url')
        'Collection Name': model.get('clipped_collection')

      kiss_track_event("View Article", data)

    viewed_related_article: (related_article_model, related_article_parent_model) ->
      data =
        'Parent Article Title': related_article_parent_model.get('title')
        'Parent Article URL': related_article_parent_model.get('content_source').get('url')
        'Related Article Title': related_article_model.get('title')
        'Related Article URL': related_article_model.get('content_source').get('url')

      kiss_track_event("View Related Article", data)

    viewed_collection: (model) ->
      data =
        'Title': model.get('name')
        'Collection ID': model.get('id')

      kiss_track_event("View Collection", data)

    installed_chrome_extension: ->
      kiss_track_event("Install Chrome Extension")
)()
