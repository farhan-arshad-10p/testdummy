Feature: Users can follow others
  Scenario: A logged in user should be able to follow other users
    Given There are other users in the system
      And I am logged in
     When I follow another user
      And I visit my followed users
     Then I should see them as a followed user

     When I unfollow a user from my following page
     Then I should not see them as a followed user

  Scenario: A logged in user should be able to unfollow other users
    Given I am logged in
      And I am following another user
     When I unfollow another user
      And I visit my followed users
     Then I should not see them as a followed user
