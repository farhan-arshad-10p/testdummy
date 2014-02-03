App.LoadMoreView = Ember.View.extend Ember.ViewTargetActionSupport,
  templateName: "loadMore"
  classNames: ['app-load-more', 'load-more', 'text-center']

  didInsertElement: ->
    elem = @$().first('.app-load-more')
    action = =>
      @triggerAction(action: 'showMore', actionContext: @)
    action()
    $(window).scroll (event) =>
      docViewTop = $(window).scrollTop()
      docViewBottom = docViewTop + $(window).height()
      elemTop = $(elem).offset().top
      if elemTop - 300 <= docViewBottom
        Ember.run.throttle {}, action, 1000
