Feature: Track the logged in player across the game
  As a player
  so that I can play as my account
  I want to have my player ID be used across the application when I am logged in

  Background:
    Given the following items exist:
      | name   | description                      | value |
      | apple  | crunchy, fresh from a tree       | 2     |
      | orange | tangy, fresh from a tree as well | 3     |

    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | email           | uid  | provider      |
      | Stella    | programmer  |        5        | 0       |       1         | stella@test.com | 1234 | google_oauth2 |
      | Kiran     | farmer      |       10        | 7       |       2         | kiran@test.com  | 1234 | google_oauth2 |

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
      | Lightfoot | comedian   | 15              | 0       | 1             | dad          | insert dad joke here | 1                  | 5                 | orange         | apple         |

    And the following inventory entries exist:
      | item   | character     | quantity |
      | apple  | Stella        | 5        |
      | orange | Kiran         | 2        |
      | orange | Ritchey       | 3        |
      | apple  | Lightfoot     | 1        |

    And the following shopping list entries exist:
      | item     | level   | quantity   |
      | apple    | 1       | 2          |
      | orange   | 2       | 4          |

  Scenario Outline: The home page shows the current player when logged in
    Given I am logged in as "<player>"
    And I am on the home page
    Then I should see "Hello <player>!"

    Examples:
      | player   |
      | Stella   |
      | Kiran    |

  Scenario: The inventory page shows the active player
    Given I am logged in as "Stella"
    And I am on the home page
    When I click on "Inventory"
    Then I should be on the inventory page for "Stella"
    And I should see "apple"
    And I should see the "Quantity" is "5"
    And I should see the "Description" is "crunchy, fresh from a tree"

  Scenario Outline: The shopping list page shows the active player
    Given I am logged in as "<player>"
    And I am on the shopping list page
    Then I should see "<correct quantity>" "<correct item>" from world "<correct world>":
    And I should not see "<wrong quantity>" "<wrong item>" from world "<wrong world>":

    Examples:
      | player   | correct item | correct quantity | correct world | wrong item | wrong quantity | wrong world |
      | Kiran    | orange       | 4                | 2             | apple      | 2              | 1           |
      | Stella   | apple        | 2                | 1             | orange     | 4              | 2           |

  Scenario Outline: The trading page shows the current player
    Given I am logged in as "<player>"
    And I am on the counter offer page for "Ritchey"
    Then I should see "<player>'s Inventory"

    Examples:
      | player   |
      | Stella   |
      | Kiran    |