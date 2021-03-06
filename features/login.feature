Feature: Login
  To ensure the safety of the application
  An admin user
  Must authenticate before doing any admin functions
 
  Scenario Outline: Failed Login
    Given I am not authenticated
    When I go to /login
    And I fill in "name" with "<mail>"
    And I fill in "password" with "<password>"
    And I press "Log In"
    Then the login request should fail
    Then I should see an error message
  
    Examples:
      | mail           | password       |
      | not_an_address | nil            |
      | not@not        | 123455         |
      | 123@abc.com    | wrong_paasword |


  Scenario: Successfull Login
    Given I am not authenticated
    And a valid user account exists
    When I login
    Then the login request should succeed
    And I should see logged in message
