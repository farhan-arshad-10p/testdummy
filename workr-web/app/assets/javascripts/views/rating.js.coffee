App.RatingView = Ember.View.extend
  templateName: 'articles/rating'
  tagName: 'div'
  classNames: ['app-article-rating', 'article-ratings', 'btn-group']
  classNameBindings: ['userRated:user:average', 'interactive:interactive']
  interactive: false

  selectedValue: ( ->
    rating_model = @get('content').get('rating')
    if rating_model
      rating_model.get('rating')
    else
      0
  ).property('content.rating.rating')

  averageValue: ( ->
    @get('content').get('average_rating')
  ).property('content.average_rating')

  stars: ( ->
    starz = []
    val = if @get('userRated') then @get('selectedValue') else @get('averageValue')
    for n in [5..1]
      starz.push(
        {
          rating: n
          highlight: if n > val then 'off' else 'on'
        }
      )
    starz
  ).property('selectedValue', 'averageValue')

  userRated: ( ->
    @get('selectedValue') > 0
  ).property('selectedValue')

  click: (event) ->
    rating = $(event.target).parent().data('rating')
    @get('controller.controllers.currentUser').rateArticle(@get('content'), rating)
