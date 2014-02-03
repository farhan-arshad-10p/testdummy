App.Rating = DS.Model.extend
  article: DS.belongsTo 'article'
  rating: DS.attr 'number'
