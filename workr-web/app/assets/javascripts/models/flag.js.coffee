App.Flag = DS.Model.extend
  reason: DS.attr 'string'
  article: DS.belongsTo('article')
