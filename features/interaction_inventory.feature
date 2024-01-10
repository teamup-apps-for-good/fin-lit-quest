Feature: Interact with inventory
  As a player
  I want to click on inventory fields
  So that I can interact with them

  Background:
    Given the following characters exist:
      | type    | name      | occupation  | inventory_slots | balance |    current_level   | personality   | dialogue_content   |
      | Player         | Stella    | farmer      |        5        | 0       |     1      |     -         |     -      |
      | Nonplayer        | Ritchey   | merchant    |        10       | 0       |     -      | enthusiastic  |   hello    |
      | Nonplayer        | Lightfoot | comedian    |        15       | 0       |     -      |    dad        |   goodbye  |

    Given the following inventory table exists:
      | item  | owner_id     | quantity |
      | apple | Stella    | 5        | 

  Scenario: View Item Information
    Given I am on the "Inventory" page
    When I click on "apple"
    Then I should be on the "Item" page for "apple"
    And I should see "apple" information

  Scenario: View Player Owner Information
    Given I am on the "Inventory" page
    When I click on "Stella"
    Then I should be on the "Player" page for "Stella"
    And I should see "Stella" information

  Scenario: View Non-Player Owner Information
    Given I am on the "Inventory" page
    When I click on "Ritchey"
    Then I should be on the "Non-Player" page for "Ritchey"
    And I should see "Ritchey" information

  Scenario: View Item quantity
    Given I am on the "Inventory" page
    Then I should see a "quantity" of "5" for "apple"