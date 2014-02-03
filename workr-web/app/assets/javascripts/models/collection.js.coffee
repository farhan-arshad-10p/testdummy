App.Collection = DS.Model.extend
  name: DS.attr 'string'
  description: DS.attr 'string'
  teaser_image: DS.attr 'string'
  articles: DS.hasMany('article', async: true)
  # user: DS.belongsTo('user', async: true)
  # Unsure why async: true causes to break.
  # Bug reported 9/6
  user: DS.belongsTo('user')
  article_count: DS.attr 'string'
  is_editable: DS.attr 'boolean'
