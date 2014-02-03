@stub_embedly
Feature: Admin can import a urls
  Scenario: An administrator can import an evernote export into the system
    Given I am an admin user
      And there is a user with a collection
    When I import an evernote export into their collection
    Then I should see a new article in the collection

  Scenario: An administrator can import an evernote export into the system with a video url
    Given I am an admin user
      And there is a user with a collection
    When I import an evernote export with video into their collection
    Then I should see a video article in the collection
