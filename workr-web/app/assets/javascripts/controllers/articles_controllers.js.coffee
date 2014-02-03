App.ArticlesNewController = Ember.ObjectController.extend
  needs: ['currentUser', 'application']
  new_collection_name: ''
  updateCollection: ( ->
    # FIXME - Tied in with the save action becameValid workaround
    errors = @get('errors.collections')
    @set('errors.collections', []) if errors
  ).observes('model.collection')


App.ArticlesEditController = Ember.ObjectController.extend
  needs: ['currentUser', 'application']

App.ArticlesShowController = Ember.ObjectController.extend
  needs: ['currentUser', 'application']
