Feature: Interact with item
  As a player
  I want to click on an item
  So that I can interact with it

  Background:
    Given the following characters exist:
      | type    | name      | occupation  | inventory_slots | balance |    current_level   | personality   | dialogue_content   |
      | Player         | Stella    | farmer      |        5        | 0       |     1      |     -         |     -      |
      | Nonplayer        | Ritchey   | merchant    |        10       | 0       |     -      | enthusiastic  |   hello    |
      | Nonplayer        | Lightfoot | comedian    |        15       | 0       |     -      |    dad        |   goodbye  |

    And the following inventory table exists:
      | item  | owner_id     | quantity |
      | fish  | 2   | 3        |
      | apple | 1    | 5        |

    And the following items table exist:
      |  name  |                 description                  |  value  |
      |  fish  |   still floppin around, fresh from the ocean |    1    |
      |  apple |   crunchy, fresh from the tree               |    2    |

  Scenario: Verify item's name
    Given I am on the "Inventory" page
    When I click on "fish"
    Then I should be on the "Item" page for "fish"
    And I should see "fish"

  Scenario: View item's description
    Given I am on the "Inventory" page
    When I click on "fish"
    Then I should be on the "Item" page for "fish"
    And I should see "still floppin around, fresh from the ocean" as a description for "fish"

  Scenario: View item's value
    Given I am on the "Inventory" page
    When I click on "fish"
    Then I should be on the "Item" page for "fish"
    And I should see "1" for "fish"