App.CollectionsIndexRoute = Ember.Route.extend
  model: (params) ->
    @store.find('collection')

