Feature: View Character Information
  As a player
  I want to click on characters on the screen
  So that I can know more about a character

  Background:
  Given the following items exist:
    | name   | description                      | value |
    | apple  | crunchy, fresh from a tree       | 2     |
    | orange | tangy, fresh from a tree as well | 3     |

  Given the following players exist:
    | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
    | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |

    Given I am logged in as "Stella"

    Given the following non-players exist:
    | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
    | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
    | Lightfoot | comedian   | 15              | 0       | 1             | dad          | insert dad joke here | 1                  | 5                 | orange         | apple         |

  Scenario: Verify characters exist
    Given I am on the character page 
    Then I should see "Players"
    And I should see "Non-players"

  Scenario: Verify a player exists
    Given I am on the character page
    When I click on "Players"
    Then I should be on the Players page
    And I should see "Stella"

  Scenario: Verify a non-player exists
    Given I am on the character page
    When I click on "Non-players"
    Then I should be on the Non-players page
    And I should see "Ritchey"
    And I should see "Lightfoot"

  Scenario: Verify a character has an occupation
    Given I am on the Player page for "Stella"
    Then I should see "programmer"

  Scenario: Verify a character has inventory_slots
    Given I am on the Non-player page for "Ritchey"
    Then I should see "Inventory slots: 10"
  
  Scenario: Verify a balance is displayed for a non-player character
    Given I am on the Non-player page for "Lightfoot"
    Then I should see "Balance: 0"
  
  Scenario: Verify a non-player has personality
    Given I am on the Non-player page for "Lightfoot"
    Then I should see "comedian"

  Scenario: Verify a non-player character has dialogue available
    Given I am on the Non-player page for "Ritchey"
    Then I should see "Howdy"
