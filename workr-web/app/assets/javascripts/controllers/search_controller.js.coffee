App.SearchController = Ember.ArrayController.extend
  needs: ['application']

  hasMore: false

  articles: ( ->
    @get('model')
  ).property('model.[]')
  collections: ( ->
    @get('model').getEach('collection').uniq().compact()
  ).property('model.[]')
  contentObserver: ( ->
    meta = @store.metadataFor("feed")
    @set('hasMore', !!meta.next_page)
  ).observes('model.[]')
