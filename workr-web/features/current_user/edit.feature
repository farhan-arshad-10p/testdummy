Feature: Users can edit their profile
  Scenario: A logged in user should be able to edit their profile
    Given I am logged in
     When I edit my profile
     Then I should see my profile updated

  Scenario: A logged in user should be able to edit their avatar
    Given I am logged in
     When I edit my avatar
     Then I should see my new avatar 

