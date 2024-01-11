Feature: View Item Information
  As a player
  I want to click on an item 
  so that I can know an item's value
  
  Background:
    Given the following items exist:
      |  name  |                 description                  |  value  |
      |  fish  |   still floppin around, fresh from the ocean |    1    |
      |  apple |   crunchy, fresh from the tree               |    2    | 

    And the following characters exist:
      | type       | name      | occupation  | inventory_slots | balance |    current_level   |
      | Player     | Stella    | farmer      | 5               | 0       |    1               |

    And the following inventory table exists:
      | item  | owner     | quantity |
      | apple | Stella    | 5        |

  Scenario: View item's name
    Given I am on the "inventory" page for "Stella"
    When I click on "fish"
    Then I should be on the "Item" page for "fish"
    And I should see "fish"

  Scenario: View item's description
    Given I am on the "inventory" page for "Stella"
    When I click on "fish"
    Then I should be on the "Item" page for "fish"
    And I should see "still floppin around, fresh from the ocean" as a description for "fish"
  
  Scenario: View item's value
    Given I am on the "inventory" page for "Stella"
    When I click on "fish"
    Then I should be on the "Item" page for "fish"
    And I should see "1" for "fish"
