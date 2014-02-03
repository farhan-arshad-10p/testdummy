@search
Feature: General user navigation
  Scenario: Given I am logged in to the system then I can log out
    Given I am logged in
    Then I should see my user in the chrome
    When I click log out
    Then I am no longer logged in

  Scenario: Given I am looking at an article then I can see the user who clipped it
    Given There is a user with some clips
     And I am logged in
    When I click the user link in the article view
    Then I see the user who clipped the article and their collections

  Scenario: Given I am looking at an article then I can see the collection its in
    Given There is a user with some clips
     And I am logged in
    When I click the collection link in the article view
    Then I see the collection that the article has been clipped to
