App.SettingsTemplateView = Ember.View.extend
  didInsertElement: ->
    $('.app-avatar-file-trigger').click ->
      $('.app-avatar-file').trigger('click')
      false

    $('.app-avatar-file').fileupload(
      dataType: 'json'
      url: '/api/avatars'
      start: =>
        Pace.options.ghostTime = 3000
        Pace.restart()
      stop: =>
        Pace.stop()
      done: (e, data) =>
        @controller.content.set('avatar_url', data.result.user.avatar_url)
    )
