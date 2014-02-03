Feature: Logged in users can clip via the clip interface
  Scenario: Given I am logged in, I can use the clipper to make a new article
    Given I am logged in and have some collections
    When I open the clipper
     And I fill in the content source and submit
     And I fill in the article information and submit
    Then I see the success message and confirm

  Scenario: Given I am logged in, I can clip another users articles
    Given I am logged in and have some collections
      And there is another user with collections and articles
    When I clip another users article
    Then I should see it in my collection

  Scenario: Given I am logged in, I can clip a url and go directly to creating an article
    Given I am logged in and have some collections
    When I clip a url
    Then I should see the article create page for that content source

  Scenario: Given I attempt to clip before logging in I should be redirected to login and back to clip after a successful login
    Given I am not logged in
    When I clip a url
    Then I should be on the login page

    When I signin
    Then I should be on the clip page

  Scenario: Given I am logged in, I can create a collection when I clip
    Given I am logged in and have some collections
    When I clip a url
    Then I should see the article create page for that content source

    When I create a new collection and finish clipping the article
    Then I should see the new collection with the new article clip

  Scenario: Given I am logged in, I can save articles from others' collections
    Given I am logged in and have some collections
      And there are articles in the system
    When I view an article
    Then I can save the viewed article to one of my collections

  Scenario: Given I am logged in, I can clip a file and go directly to creating an article
    Given I am logged in and have some collections
    When I upload a template
    Then I should see the article create page for the uploaded file
