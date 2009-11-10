Feature: Show
  To allow users to read specific articles
  A user selecting a specific article
  Should see only that article and comment form

  Scenario: Click the title to show
    Given 2 posts exist
    When I go to /
    And I follow "post 1"
    Then the request should succeed
    And I should see only post 1
