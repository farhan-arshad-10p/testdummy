@search
Feature: Users can view their feed
  Scenario: A logged in user should be able to view their feed (1)
    Given I am a user with a single interest
      And I follow another user with articles
      And there are multiple articles in the system
     When I view my feed
     Then I should see my feed with the articles related to my interest
      And I should see articles from my followed users

  Scenario: A logged in user should be able to view their feed (2)
    Given I am a user with mulitple interests
      And there are multiple articles relating to my interests 
      And articles unrelated to my interests
     When I view my feed
     Then I should see my feed with the articles related to my interests
      And I should not see articles unrelated to my interests
