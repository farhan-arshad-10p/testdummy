@search
Feature: Users can rate an article
  Scenario: A logged in user viewing an article should be able to give it a rating
    Given I am a user viewing an article
    When I rate the article 
    Then I should see my rating saved on the article

  Scenario: A logged in user viewing an article should see the average rating
    Given I am a user viewing an article
    When the article has mutliple ratings
    Then I should see the average rating
