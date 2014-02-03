App.ViewedArticle = DS.Model.extend
  user: DS.belongsTo('user')
  article: DS.belongsTo('article')
