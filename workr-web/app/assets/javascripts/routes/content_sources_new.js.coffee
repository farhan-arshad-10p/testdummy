App.ContentSourcesNewRoute = Ember.Route.extend
  model: (params) ->
    @store.createRecord('content_source')


  actions:
    save: (model) ->
      model.save().then(( (model) =>
          @controller.transitionToRoute('articles.new', model)
        ),
        (=>
          console.log "didn't save"
        ))
