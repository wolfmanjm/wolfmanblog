Feature: Admin
  To ensure the safety of the application
  A normal user
  Should not be able to delete or edit posts or comments

  Scenario: cannot delete post
    Given I am not authenticated
    When I DELETE /posts id 1
    Then the request should return status 401

  Scenario: cannot delete comment
    Given I am not authenticated
    When I DELETE /comments id 1
    Then the request should return status 401

  Scenario: cannot edit post
    Given I am not authenticated
    When I PUT /posts id 1
    Then the request should return status 401

  Scenario: cannot create post
    Given I am not authenticated
    When I POST /posts
    Then the request should return status 401

  Scenario: cannot upload post
    Given I am not authenticated
    When I POST /posts/upload
    Then the request should return status 401

