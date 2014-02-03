App.Feed = DS.Model.extend
  title: DS.attr 'string'
  articles: DS.hasMany('article', async: true)
