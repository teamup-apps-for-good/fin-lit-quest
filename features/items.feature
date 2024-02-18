Feature: View Item Information
  As a player
  I want to view item information
  so that I can know what items are in the game
  
  Background:
    Given the following items exist:
      |  name   |                 description                  |  value  |
      |  apple  |   crunchy, fresh from the tree               |    2    | 
      |  fish   |   still floppin around, fresh from the ocean |    1    |
      |  orange |   juicy, fresh from the tree                 |    3    | 
      |  wheat  |   grainy, fresh from the field               |    1    |

    And the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  |
      | Stella    | programmer  |        5        | 0       |       1         |

    And the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |

    And the following inventory entries exist:
      | item  | character        | quantity |
      | apple | Stella           | 5        |
      | fish  | Ritchey          | 4        |

  Scenario: Verify a item can be created
    Given I am on the items page
    And I click on "New item"
    And I fill in Name as "orange", Description as "juicy, fresh from the tree", and Value as "2"
    And I click on "Create Item"
    And I click on "Back to items"
    Then I should be on the items page
    And I should see "orange"
  
  Scenario: Verify items are viewable
    Given I am on the items page
    Then I should see "apple"
    And I should see "fish"
    And I should not see "grape"

  Scenario: Verify I can show an item
    Given I am on the items page
    And I click on "Show apple"
    Then I should see "apple"
    And I should not see "fish"

  Scenario: Verify you can edit an item
    Given I am on the item page for "apple"
    And I click on "Edit this item"
    And I fill in Name as "fish", Description as "still floppin around, fresh from the ocean", and Value as "4"
    And I click on "Update Item"
    And I click on "Back to items"
    Then I should be on the items page
    And I should not see "apple"
    And I should see "fish"

  Scenario: Verify you can delete an item
    Given I am on the item page for "wheat"
    And I click on "Destroy this item"
    Then I should be on the items page
    And I should not see "wheat"