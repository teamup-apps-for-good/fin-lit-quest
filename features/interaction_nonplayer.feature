Feature: Interact with NPCs
  As a player
  I want to click on NPCs
  So that I can interact with them

  Background:
    Given the following characters exist:
      | type    | name      | occupation  | inventory_slots | balance |    current_level   | personality   | dialogue_content   |
      | Player         | Stella    | farmer      |        5        | 0       |     1      |     -         |     -      |
      | Nonplayer        | Ritchey   | merchant    |        10       | 0       |     -      | enthusiastic  |   hello    |
      | Nonplayer        | Lightfoot | comedian    |        15       | 0       |     -      |    dad        |   goodbye  |

  Scenario: Visit a Non-Player Character's page
    Given I am on the "Town" page 
    When I click on "Ritchey"
    Then I should be on the "Non-Player" page for "Ritchey"

  Scenario: View a Non-Player Character's Occupation
    Given I am on the "Non-Player" page for "Ritchey"
    Then I should see "merchant"

  Scenario: View a Non-Player Character's Inventory Slots
    Given I am on the "Non-Player" page for "Lightfoot"
    Then I should see "Lightfoot" has "15" "Inventory Slots"

  Scenario: View a Non-Player Character's balance
    Given I am on the "Non-Player" page for "Lightfoot"
    Then I should see a "balance" of "0"

  Scenario: View a Non-Player Character's level
    Given I am on the "Non-Player" page for "Ritchey"
    Then I should see "level" number "1"

  Scenario: View a Non-Player Character's personality
    Given I am on the "Non-Player" page for "Ritchey"
    Then I should see "enthusiastic"

  Scenario: View a Non-Player Character's dialogue
    Given I am on the "Non-Player" page for "Lightfoot"
    Then I should see "goodbye"
