Feature: Gameover Page

As a player
so that I can recover from a game over state
I want to the game over page to have good styling and allow me to go back to the start with new starter items

  Background:
    Given the following players exist:
      | name       | occupation | inventory_slots | balance | current_level | uid  | provider      | email         |
      | Player     | programmer | 5               | 0       | 2             | 5678 | google_oauth2 | test@test.com |
    Given the following items exist:
      | name   | description                                        | value |
      | wheat  | grainy, fresh from the field                       | 1     |
      | boots  | sturdy and waterproof, fresh from the cobbler      | 25    |
      | grapes | -                                                  | 2     |
    Given the following starter item table exists:
      | item   | quantity |
      | wheat  | 10       |
      | boots  | 1        |
      | grapes | 3        |

  Scenario: I can see the game over button
    Given I am logged in as "Player"
    And I am on the game over page
    Then I should see "Restart"

  Scenario: I can click the restart button and restart game
    Given I am logged in as "Player"
    And I am on the game over page
    When I click on "Restart"
    Then I should be on the home page
    And I should see "Game restarted successfully."

Scenario: After restarting my inventory should not be empty
    Given I am logged in as "Player"
    And I am on the game over page
    When I click on "Restart"
    Then I should be on the home page
    And "Player"'s inventory should not be empty
