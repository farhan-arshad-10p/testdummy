@search
Feature: Users can search their feed
  Scenario: A logged in user should be able to view their search feed
    Given I am a user viewing mulitple articles on my feed
    When I search my feed for a term
    Then I should see my feed narrowed down based on my search term

    When I click the article search result
    Then I should be able to see the individual article

  Scenario: A logged in user should be able to view their search feed by type
    Given I am a user viewing mulitple articles on my feed
    When I search for a popular term
    Then I should see all articles for that term
     And I should be able to filter to just the image articles
     And I should be able to filter to just the video articles

  Scenario: A user should be able to view information about an article
    Given I am a user viewing mulitple articles on my feed
    When I search my feed for a term
    Then I should see attribution on the article

    When I click the article search result
    Then I should see interactive attribution on the individual article

  Scenario: A logged in user should be able to view their search in collection mode
    Given I am a user viewing mulitple articles on my feed
    When I search my feed for a term
    Then I should see my feed narrowed down based on my search term

     When I change to collection view
     Then I should see all the collections that contain articles related to my search

  Scenario: A logged in user should be able to view their search in collection mode
    Given I am a user viewing mulitple articles on my feed
      And There are many users in the system
    When I search my feed for a user name
     And I change to user view
     Then I should see all the users that match my search
