App.ArrayTransform = DS.Transform.extend
  serialize: (jsonData) ->
    if Ember.typeOf(jsonData) == 'array'
      jsonData
    else if Ember.typeOf(jsonData) == 'string'
      jsonData.split(",")
    else
      []

  deserialize: (externalData) ->
    if Ember.typeOf(externalData) == 'array'
      externalData
    else
      []

App.Store = DS.Store.extend
  revision: 13

DS.Store.reopen
  recordWasError: (record, reason) ->
    if reason && reason.responseJSON.errors
      record.adapterDidInvalidate(reason.responseJSON.errors)
    else
      record.adapterDidError()

  properDeleteChild: (model, callback) ->
    Ember.Logger.warn("Deleting child model using workaround - please investigate: https://github.com/emberjs/data/issues/1308 - Still present 10/18/13")
    model.eachRelationship (name, relationship) ->
      if relationship.kind is "belongsTo"
        inverse = relationship.parentType.inverseFor(name)
        parent = model.get(name)
        parent.get(inverse.name).removeObject model  if inverse and parent

    model.deleteRecord()
    if callback
      model.save().then ->
        callback()
    else
      model.save()
