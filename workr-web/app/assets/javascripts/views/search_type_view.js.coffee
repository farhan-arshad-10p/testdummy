App.SearchTypeView = Ember.View.extend Ember.ViewTargetActionSupport,
  tagName: "a"
  classNames: ["btn", "btn-link", "app-type-select"]
  classNameBindings: ["isActive:active", "type"]
  isActive: (->
    @get('type') == @get('selected')
  ).property('type', 'selected')

  click: ->
    app_controller = @get('controller').get('controllers.application')
    App.Router.router.transitionTo('search', app_controller.get('search'), queryParams: {type: @get('type')})
