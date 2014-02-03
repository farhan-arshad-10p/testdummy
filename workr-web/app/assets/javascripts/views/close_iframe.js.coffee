App.CloseIframe = Ember.View.extend
  didInsertElement: ->
    $('html').fadeOut 1600, ->
      window.parent.postMessage("closeWindow", "*")
