Feature: View inventory Information
  As a player
  I want to view inventory information
  so that I can keep track of the items I currently own in the game

  Background:
    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  |
      | Stella    | programmer  |        5        | 0       |       1         |
    
    And the following items exist:
      |  name   |                 description                  |  value  |
      |  fish   |   still floppin around, fresh from the ocean |    1    |
      |  apple  |   crunchy, fresh from the tree               |    2    | 
      |  orange |   juicy, fresh from the tree                 |    3    | 

    And the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |

    And the following inventory table exists:
      | item  | character        | quantity |
      | apple | Stella           | 5        |
      | fish  | Ritchey          | 4        |
    
  Scenario: Verify inventories are viewable
    Given I am on the inventories page
    Then I should see "apple"
    And I should not see "grape"

  Scenario: Verify I can show an inventory item
    Given I am on the inventories page
    And I click on "Show apple in Stella's inventory"
    Then I should see "apple"
    And I should not see "fish"

  Scenario: Verify you can delete an inventory item
    Given I am on the inventory page for "apple" that is owned by "Stella"
    And I click on "Destroy this inventory"
    Then I should be on the inventories page
    And I should not see "apple"

  Scenario: Verify I can show an inventory item
    Given I am on the inventories page
    And I click on "Show apple in Stella's inventory"
    Then I should see "apple"
    And I should not see "fish"
    And I should not see "orange"

  Scenario: Verify you can edit an inventory item
    Given I am on the inventory page for "fish" that is owned by "Ritchey"
    And I click on "Edit this inventory"
    And I select "orange" from the "Item" dropdown
    And I select "Stella" from the "Character" dropdown
    And I fill in "Quantity" with "7"
    And I click on "Update Inventory"
    And I click on "Back to inventories"
    Then I should be on the inventories page
    And I should see "orange"
    And I should not see "fish"

  Scenario: Verify a new inventory item can be created
    Given I am on the inventories page
    And I click on "New inventory"
    And I select "orange" from the "Item" dropdown
    And I select "Ritchey" from the "Character" dropdown
    And I fill in "Quantity" with "4"
    And I click on "Create Inventory"
    And I click on "Back to inventories"
    Then I should be on the inventories page
    And I should see "orange"