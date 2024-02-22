Feature: Failure consequences
  As a player
  so that the game has challenge
  I want the state of failing to pay a recurring expense to lead to consequences

  Background:

  
    Given the following players exist:
    | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
    | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |
    
    Given I am logged in as "Stella"

    Given the following items exist:
      | name   | description                                        | value |
      | apple  | crunchy, fresh from the tree                       | 2     |
      | orange | tangy, fresh from the tree                         | 2     |
      | wheat  | grainy, fresh from the field                       | 1     |
      | boots  | sturdy and waterproof, fresh from the cobbler      | 25    |
      | map    | detailed and reliable, fresh from the cartographer | 15    |
      | fish   | still floppin' around, fresh from the ocean        | 3     |
      | bread  | yummy, fresh from the oven                         | 2     |

    And the following expenses table exists:
      | type      | value       | item   | quantity |
      | day       | 1           | apple  | 1        |
      | week      | 1           | orange | 2        |

    And the following inventory table exists:
      | item    | character | quantity |
      | apple   | Stella    | 1        |

  Scenario: The player can move to the next day if they can pay their expenses, even if there is no time left
    Given "Stella" is on Day "1" and Hour "10"
    And I am on the home page
    When I click on "Move to the next day"
    Then "Stella" should be on Day "2" and Hour "1"
    And I should see "8:00 AM on Day 2, Era 1"

  Scenario: The player is told they have lost if they cannot fulfill the requirements
    Given "Stella" is on Day "7" and Hour "10"
    And I am on the home page
    When I click on "Move to the next day"
    Then I should be on the game over page
    And "Stella" should be on level "0"
    And I should see "Game Over"
    And I should see a notice of "You can't afford to pay your expenses, and you have no time left!"

  Scenario: A player with game over cannot go back to the game
    Given "Stella" is on level "0"
    And I am on the home page
    Then I should be on the game over page

  Scenario: A player with game over can restart
    Given "Stella" is on level "0"
    And I am on the game over page
    When I click on "Restart"
    Then "Stella" should be on level "1"
    And "Stella" should have a balance of "0"