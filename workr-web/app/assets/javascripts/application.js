//= require pace
//= require namespace
//= require analytics
//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require workr
Ember.FEATURES["query-params"] = true
App = Ember.Application.create({
    LOG_TRANSITIONS: true,
    LOG_TRANSITIONS_INTERNAL: true,
});

DS.RESTAdapter.reopen({ 
  namespace: 'api', 
  pathForType: function(type) {
    var decamelized = Ember.String.decamelize(type);
    return Ember.String.pluralize(decamelized);
  }
});


//= require_tree .
