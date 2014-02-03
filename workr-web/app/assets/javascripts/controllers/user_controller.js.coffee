App.UserController = Ember.ObjectController.extend
  needs: ['currentUser']

  currentUser: (->
    @get('controllers.currentUser').get('model')
  ).property('controllers.currentUser.model')

  isCurrentUser: ( ->
    @get('model').get('id') == @get('currentUser').get('id')
  ).property('currentUser', 'model')

  followers: (->
    @get('model').get('followers')
  ).property('model.followers')

  isFollowing: ( ->
    cu = @get('currentUser')
    @get('followers').find (following_user) ->
      return "#{following_user.get('id')}" == "#{cu.get('id')}"
  ).property('followers.[]', 'currentUser.following.[]')

App.UserCollectionsController = Ember.ObjectController.extend
  needs: ['user']

App.UserFollowingController = Ember.ObjectController.extend
  needs: ['user']
