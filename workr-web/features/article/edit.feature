Feature: Users can edit an article
  Scenario: A logged in user should be able to view there feed
    Given I am a user viewing my collection
    When I edit an article
    Then I should see the article edit page

    When I change article information 
     And I save the article
    Then I should see the new information for ont he article
