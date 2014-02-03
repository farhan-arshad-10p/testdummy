App.CollectionsEditRoute = Ember.Route.extend
  actions:
    save: (collection) ->
      collection.save().then(
        ((collection) =>
          @controller.transitionToRoute('collections.show', collection)
        )
      )

    delete_collection: (collection) ->
      can_delete = confirm("Are you sure you want to delete your collection called #{collection.get('name')}?")
      callback = => 
        user = @controllerFor('currentUser').get('content')
        @controller.transitionToRoute('user', user.get('id'))
      @store.properDeleteChild(collection, callback) if can_delete
