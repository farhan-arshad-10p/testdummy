App.UserIndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo('user.collections')

App.UserCollectionsRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('user')

App.UserFollowingRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('user')

App.UserRoute = Ember.Route.extend
  model: (params) ->
    @store.find('user', params.user_id)

  actions:
    followUser: (user) ->
      @controllerFor('currentUser').followUser(user)
    unfollowUser: (user) ->
      @controllerFor('currentUser').unfollowUser(user)

App.UserEditRoute = Ember.Route.extend
  model: ->
    @controllerFor('currentUser').content

  actions:
    save: (model) ->
      model.save()
