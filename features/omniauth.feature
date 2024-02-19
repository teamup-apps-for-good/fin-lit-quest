Feature: Login to the game
  As a player
  so that I could play from multiple devices and have my progress restored
  I want to be able to log into the game

  Background:
    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 |

  Scenario: The home page redirects to the login page
    Given I am not logged in
    And I am on the home page
    Then I should be on the login page
    And I should see "Sign in"

  Scenario: The home page shows a welcome page when logged in
    Given I am logged in as "Stella"
    And I am on the home page
    Then I should see "Hello Stella!"

  Scenario: Logged in route redirects to the login page
    Given I am not logged in
    And I am on the inventory page for "Stella"
    Then I should be on the login page
    And I should see "Sign in"

  Scenario: The login page has a login with Google option
    Given I am not logged in
    And I am on the login page
    Then I should see "Sign in with Google"

  Scenario: Selecting the login button should bring me to the login with Google process
    Given I am not logged in
    And I am on the login page
    When I click on "Sign in with Google"
    Then I should be on the home page
    And I should see "Hello Stella!"

    # the unhappy path, where a user does not successfully log in, would be harder to test
    # as OmniAuth does not seem to have a way to mock unsuccessful logins
