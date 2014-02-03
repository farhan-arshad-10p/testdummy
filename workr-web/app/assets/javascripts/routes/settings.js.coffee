App.SettingsRoute = Ember.Route.extend
  renderTemplate: ->
    @render('settings/template')
    @render('settings/edit', into: "settings/template")

  model: ->
    @controllerFor('currentUser').content

  actions:
    save: (model) ->
      model.save()

App.SettingsAvatarRoute = Ember.Route.extend
  renderTemplate: ->
    @render('settings/template')
    @render('settings/avatar', into: "settings/template")

  model: ->
    @controllerFor('currentUser').content


App.SettingsFollowingRoute = Ember.Route.extend
  renderTemplate: ->
    @render('settings/template')
    @render('settings/following', into: "settings/template")

  model: (params) ->
    @controllerFor('currentUser').content

  actions:
    unfollowUser: (user) ->
      @controllerFor('currentUser').unfollowUser(user)

App.SettingsCollectionsRoute = Ember.Route.extend
  renderTemplate: ->
    @render('settings/template')
    @render('settings/collections', into: "settings/template")

  model: (params) ->
    @controllerFor('currentUser').content
