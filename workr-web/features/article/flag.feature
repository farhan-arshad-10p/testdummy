Feature: Users can flag an article
  Scenario: A logged in user should be able to flag an article
    Given I am a user viewing an article
    When I flag the article
    Then an admin should be able to see the flagged article
