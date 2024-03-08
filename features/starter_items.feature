Feature: Starter kit
  As a player
  So that I can begin to play the game
  I want a starter kit of items

  Background:
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

  Scenario Outline: Upon creating a new account, the player has the starter kit
    Given I am not logged in
    And I am on the login page
    When I click on "Sign in with Google"
    Then "Stella" should have "<qty>" "<item>" in their inventory

    Examples:
      | qty | item  |
      | 10  | wheat  |
      | 1   | boots  |
      | 3   | grapes |

  Scenario: An already signed up player should not be given new items on sign in
    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |
    And I am not logged in
    And I am on the login page
    When I click on "Sign in with Google"
    Then "Stella"'s inventory should be empty
