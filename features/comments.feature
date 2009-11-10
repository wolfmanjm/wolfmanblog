Feature: Comments
  To allow users to make comments on an article
  A user should be able to create a comment, but spambots cannot
  So others can read the comments, but junk comments are rejected

  Scenario: a user leaves a comment
    Given 2 posts exist
    When I go to /posts/2
    And I leave a valid comment
    Then the request should succeed
    And I should see the comment

  Scenario: a spambot leaves a comment
    Given 2 posts exist
    When I go to /posts/2
    And I leave an invalid comment
    Then the request should fail
    And I should see "Error accepting your comment"
    When I go to /posts/2
    Then I should not see the comment
