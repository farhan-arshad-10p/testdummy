App.CollectionsShowRoute = Ember.Route.extend
  afterModel: (model) ->
    Analytics.viewed_collection(model)
