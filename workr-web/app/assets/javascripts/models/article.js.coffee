App.Article = DS.Model.extend
  title: DS.attr 'string'
  description: DS.attr 'string'
  clipped_name: DS.attr 'string'
  clipped_collection: DS.attr 'string'
  tag_list: DS.attr 'string'
  content_source: DS.belongsTo('content_source', async: true)
  user: DS.belongsTo('user')
  collection: DS.belongsTo('collection')
  related_articles: DS.hasMany('article', async: true, inverse: 'parent_related_articles')
  parent_related_articles: DS.hasMany('article', async: true, inverse: 'related_articles')
  is_file: DS.attr 'boolean'
  is_video: DS.attr 'boolean'
  is_image: DS.attr 'boolean'
  is_html: DS.attr 'boolean'
  content_source_id: DS.attr 'number'
  is_editable: DS.attr 'boolean'
  view_count: DS.attr 'number'
  average_rating: DS.attr 'number'
  rating: DS.belongsTo 'rating', async: true

  tags: ( ->
    @get('tag_list').split(',')
  ).property('tag_list')

