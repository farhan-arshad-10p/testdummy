App.FormGroup = Ember.View.extend
  layoutName: 'form_group'
  classNames: ['form-group']
  tagName: 'div'
  classNameBindings: ['hasErrors:has-error']
  hasErrors: ( ->
    @get('errors.length') > 0
  ).property('errors.length')
  errors: []
