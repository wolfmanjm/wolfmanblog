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

  Scenario: tags and categories are displayed
    Given 1 post exists
    And post 1 is tagged "tag1,tag2"
    And post 1 has category "cat1,cat2"

    When I go to /
    And I follow "post 1"
    Then the request should succeed
    And I should see only post 1
    And the post is tagged "tag1,tag2"
    And the post is in category "cat1,cat2"

  
