Feature: Interact with inventory
  As a player
  I want to click on inventory fields
  So that I can interact with them

  Background:
    Given the following items exist:
      | name   | description                      | value |
      | apple  | crunchy, fresh from a tree       | 2     |
      | orange | tangy, fresh from a tree as well | 3     |

    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  |
      | Stella    | programmer  |        5        | 0       |       1         |

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
      | Lightfoot | comedian   | 15              | 0       | 1             | dad          | insert dad joke here | 1                  | 5                 | orange         | apple         |

    And the following inventory exist:
      | item   | character     | quantity |
      | apple  | Stella        | 5        |
      | orange | Ritchey       | 3        |
      | apple  | Lightfoot     | 5        |

  Scenario: View Item Information
    Given I am on the inventory page
    Then I should see "apple"
    And I should see the "Amount" is "5"
    And I should see the "Description" is "crunchy, fresh from a tree"

  Scenario: View Non-Player Owner Information
    Given I am on the inventory page for "Ritchey"
    Then I should see "orange"
    And I should see the "Amount" is "3"
    And I should see the "Description" is "tangy, fresh from a tree as well"
