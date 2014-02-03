App.ArticlesShowRoute = Ember.Route.extend
  afterModel: (model) ->
    Analytics.viewed_article(model)
