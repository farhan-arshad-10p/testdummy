@search
Feature: Users can view an article
  Scenario: A logged in user should be able to view there feed
    Given I am a user viewing mulitple articles on my feed
    When I search my feed for a term
    Then I should see my feed narrowed down based on my search term

    When I click the article search result
    Then I should be able to see the individual article

  Scenario: A logged in user should see a recent views list
    Given I am a user viewing an article
    When I close the modal
    Then I should see the article in my recents list
