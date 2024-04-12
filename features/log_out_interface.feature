Feature: Logout Button

  As a player
  so that I can remove my account from this browser
  I want to click a log out button from the profile page

  Background:
    Given the following players exist:
      | name       | occupation | inventory_slots | balance | current_level | uid  | provider      | email         |
      | Stella     | programmer | 5               | 0       | 2             | 5678 | google_oauth2 | test@test.com |


  Scenario: I can see the logout button
    Given I am logged in as "Stella"
    And I am on the home page
    Then I should see "Log Out"

  Scenario: I can click the logout button and logout
    Given I am logged in as "Stella"
    And I am on the home page
    When I click on "Log Out"
    Then I should be on the login page
