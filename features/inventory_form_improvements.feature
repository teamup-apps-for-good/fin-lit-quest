Feature: In new inventory entry creation, select item and character from list
  As an admin
  so that I can make a new inventory entry without knowing the name of the item and character
  I want to be able to select the item and character from a drop down

  Background:
    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         | admin |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com | true  |

    And the following items exist:
    |  name   |                 description                  |  value  |
    |  fish   |   still floppin around, fresh from the ocean |    1    |
    |  apple  |   crunchy, fresh from the tree               |    2    |
    |  orange |   juicy, fresh from the tree                 |    3    |

    And the following non-players exist:
    | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
    | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |

    And the following inventory entries exist:
      | item  | character        | quantity |
      | apple | Stella           | 5        |
      | fish  | Ritchey          | 4        |

    Given I am logged in as "Stella"

  Scenario: Player is available to select from drop down
    Given I am on the new inventory entry page
    When I select "apple" from the "Item" dropdown
    And I select "Stella" from the "Character" dropdown
    And I fill in "Quantity" with "1"
    And I click on "Create Inventory"
    Then I should see "Inventory was successfully created."

  Scenario: Quantity is rejected if negative
    Given I am on the new inventory entry page
    When I select "apple" from the "Item" dropdown
    And I select "Stella" from the "Character" dropdown
    And I fill in "Quantity" with "-1"
    And I click on "Create Inventory"
    Then I should see "Quantity must be greater than or equal to 0"

  Scenario: Non-player is available to select from drop down
    Given I am on the new inventory entry page
    When I select "apple" from the "Item" dropdown
    And I select "Ritchey" from the "Character" dropdown
    And I fill in "Quantity" with "1"
    And I click on "Create Inventory"
    Then I should see "Inventory was successfully created."
    
  Scenario: Player is available to select from drop down on edit page
    Given I am on the inventory edit page for "apple" that is owned by "Stella"
    When I select "apple" from the "Item" dropdown
    And I select "Stella" from the "Character" dropdown
    And I fill in "Quantity" with "1"
    And I click on "Update Inventory"
    Then I should see "Inventory was successfully updated."

  Scenario: Quantity is rejected if negative on edit page
    Given I am on the inventory edit page for "apple" that is owned by "Stella"
    When I select "apple" from the "Item" dropdown
    And I select "Stella" from the "Character" dropdown
    And I fill in "Quantity" with "-1"
    And I click on "Update Inventory"
    Then I should see "Quantity must be greater than or equal to 0"

  Scenario: Non-player is available to select from drop down on edit page
    Given I am on the inventory edit page for "apple" that is owned by "Stella"
    When I select "apple" from the "Item" dropdown
    And I select "Ritchey" from the "Character" dropdown
    And I fill in "Quantity" with "1"
    And I click on "Update Inventory"
    Then I should see "Inventory was successfully updated."
