@search
Feature: Users can interact with collections
  Scenario: Users can view all collections and just their collections
    Given I am logged in
      And There are multiple collections in the system
    When I view my collections
    Then I see just my collections
    When I visit all collections
    Then I see all collections

  Scenario: Users can create new collections
    Given I am logged in
    When I create a collection
    Then I see the new collection in my collections

  Scenario: Users can delete their own collections
    Given I am logged in
      And I have a collection
    When I delete my collection
    Then I no longer see the collection in my list

  Scenario: Users can edit their own collections
    Given I am logged in
      And I have a collection
    When I edit my collection
    Then I see my edited collection
