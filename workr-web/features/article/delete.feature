Feature: Users can edit an article
  Scenario: A logged in user should be able to delete an article
    Given I am a user viewing my collection
    When I delete an article
    Then the article should be removed from the collection
