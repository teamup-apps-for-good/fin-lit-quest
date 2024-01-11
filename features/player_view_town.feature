Feature: Interact with NPCs
  As a player
  I want to click on NPCs
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

    Given the following inventory exist:
      | item   | character     | quantity |
      | apple  | Stella        | 5        |
      | orange | Ritchey       | 3        |
      | apple  | Lightfoot     | 5        |

  Scenario: Non-players exist in town
    Given I am on the town page
    Then I should see "Ritchey"
    And I should see "Lightfoot"

  Scenario: Visit a Non-Player Character's page
    Given I am on the town page
    When I click on "Ritchey"
    Then I should be on the profile page for "Ritchey"

  Scenario: View a Non-Player Character's occupation
    Given I am on the profile page for "Ritchey"
    Then I should see the "Occupation" is "client"

  Scenario: View a Non-Player Character's balance
    Given I am on the profile page for "Lightfoot"
    Then I should see the "Balance" is "0"

  Scenario: View a Non-Player Character's personality
    Given I am on the profile page for "Ritchey"
    Then I should see the "Personality" is "enthusiastic"

  Scenario: View a Non-Player Character's dialogue
    Given I am on the trade page for "Lightfoot"
    Then I should see "insert dad joke here"
