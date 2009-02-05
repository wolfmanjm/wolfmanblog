Feature: Index
  To allow browsing of the blog
  A user going to the index page
  Should see a list of paged articles
 
  Scenario: GET /
    Given 8 posts exist
    When I go to /
    Then the request should succeed
    And I should see post 1
    And I should see post 2
    And I should see post 3
    And I should see post 4
    And I should not see post 5

  Scenario: GET next page
    Given 8 posts exist
    When I go to /
    And I follow "2"
    Then the request should succeed
    And I should see post 5
    And I should see post 6
    And I should see post 7
    And I should see post 8
    And I should not see post 1

  Scenario: GET / has sidebar

