Feature: Admin users can upload files through the admin panel

  Scenario: Given the admin user is logged in they should be able to upload files
    Given I am an admin user
     And I am on the admin panel
    When I add a new file upload
    Then I should see it appear in the uploaded file list

  Scenario: Given the admin user has a hosted file the should be able to make an article from it
    Given I am an admin user
     And I have added a file upload
    When I import the upload as an article
    Then I should see the article for the file I uploaded

