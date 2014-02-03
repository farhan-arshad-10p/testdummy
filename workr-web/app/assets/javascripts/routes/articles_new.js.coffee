App.ArticlesNewRoute = Ember.Route.extend
  model: (params) ->
    @store.find('content_source', @modelFor('articles').id).then (content_source) =>
      Analytics.clipped_url(content_source.get('url'))
      @store.createRecord('article', collection: null, content_source_id: content_source.get('id'), title: content_source.get('title'))

  actions:
    save: (model) ->
      # FIXME - Dropdown does not clear error, so we have to manually do this
      cs = model.get('currentState')
      cs.becameValid(model) if cs.becameValid
      
      model.save().then( =>
        Analytics.created_article(model)
        # FIXME - the following line should not be needed to load the relationships...
        model.get('collection').get('articles').pushObject model
        @controller.transitionToRoute('articles.show', model)
      )

    create_collection: ->
      current_user = @controllerFor("currentUser").content
      collection = current_user.get("collections").content.createRecord(name: @controller.get('new_collection_name'))
      collection.save().then( =>
        Analytics.created_collection(collection)
        @controller.set("new_collection_name", '')
        @controller.set("collection", collection)
      )
