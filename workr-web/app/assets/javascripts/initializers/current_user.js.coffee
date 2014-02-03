Ember.Application.initializer
  name: 'currentUser'

  initialize: (container) ->
    store = container.lookup('store:main')
    attributes = $('meta[name="current-user"]').attr('content')

    if attributes
      attrs = JSON.parse(attributes)
      attrs.current_user = true
      store.push('user', attrs)
      user = store.find('user', attrs.id)
      controller = container.lookup('controller:currentUser').set('content', user)
