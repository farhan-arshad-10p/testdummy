App.CollectionsNewRoute = Ember.Route.extend
  model: (params) ->
    current_user = @controllerFor("currentUser").content
    collection = current_user.get("collections").content.createRecord()
  actions:
    save: (collection) ->
      collection.save().then(
        ((collection) =>
          @controller.transitionToRoute 'collections.show', collection
        )
      )
