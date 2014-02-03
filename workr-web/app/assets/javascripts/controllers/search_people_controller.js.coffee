App.SearchPeopleController = Ember.ArrayController.extend
  needs: ['application']

  hasMore: false

  people: ( ->
    @get('model')
  ).property('model.[]')

  contentObserver: ( ->
    meta = @store.metadataFor("user")
    @set('hasMore', !!meta.next_page)
  ).observes('model.[]')
