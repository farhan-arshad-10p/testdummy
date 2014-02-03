Feature: Users can access the system via an invite code

  Scenario: Given the user has a active invite they should be able to sign up from the login page
    Given there is an invite in the system
      And some interests exist in the system 
     When I access the root page
      And I submit my invite
      And I register via email
     Then I should see the new user form

  Scenario: Given the user has a active invite they should be able to sign up
    Given there is an invite in the system
     And some interests exist in the system 
    When I access the invite
     And I register via email
    Then I should see the new user form

    When I submit the new user form
    Then the invite should be tied to my user account 
     And the invite should be inactive

  Scenario: Given the user has a inactive invite
    Given there is an inactive invite in the system
    When I access the invite
    Then I should be redirected to the sign in page 

  Scenario: Given the user is sans invite
    Given there are no invites in the system
    When I access the sign up page
    Then I should be redirected to the sign in page 

  Scenario: Given the user declines the terms of service
    Given there is an invite in the system
     And some interests exist in the system 
    When I access the invite
     And I register via email
    Then I should see the new user form

    When I submit the new user form without accepting the ToS
    Then I should be returned to the new user form

  Scenario: Given the user is already logged in they should be redirected on an active invite
    Given I am logged in
     When I access an active invite
     Then I should see the feed page

  Scenario: Given the user is already logged in they should be redirected on an inactive invite
    Given I am logged in
     When I access an inactive invite
     Then I should see the feed page
