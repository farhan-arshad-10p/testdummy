App.ArticlesEditRoute = Ember.Route.extend
  actions:
    update: (model) ->
      model.save().then( => @controller.transitionToRoute('articles.show', model))

    delete_article: (article) ->
      can_delete = confirm("Are you sure you want to remove #{article.get('title')}?")
      collection = article.get('collection')
      callback = => 
        @controller.transitionToRoute('collections.show', collection.id)
      @store.properDeleteChild(article, callback) if can_delete
