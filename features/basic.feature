Feature: Home Page

  These are very basic tests to check that authentication
  is working correctly.

  Scenario: Home page goes to login when not logged in
    Given that I'm not logged in
    When I hit the home page
    Then I should be redirected to a login page

  Scenario: Shows up when logged in
    Given that I'm a valid user
    When I hit the home page
    Then I should see a page
