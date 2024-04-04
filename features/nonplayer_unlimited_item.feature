Feature: Unlimited Items for NPC

  As a player
  So that I can continuously trade with an NPC even when other players trade
  I want an NPC to have unlimited items

  Background:
    Given the following items exist:
      | name   | description                                        | value |
      | apple  | crunchy, fresh from the tree                       | 2     |
      | orange | tangy, fresh from the tree                         | 2     |
      | wheat  | grainy, fresh from the field                       | 1     |
      | boots  | sturdy and waterproof, fresh from the cobbler      | 25    |
      | map    | detailed and reliable, fresh from the cartographer | 15    |
      | fish   | still floppin' around, fresh from the ocean        | 3     |
      | bread  | yummy, fresh from the oven                         | 2     |

    Given the following players exist:
      | name   | occupation | inventory_slots | balance | current_level | uid  | provider      | email         |
      | Stella | programmer | 5               | 0       | 1             | 1234 | google_oauth2 | test@test.com |

    Given I am logged in as "Stella"

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
      | Alice     | fisherman  | 15              | 0       | 1             | tired        | zzz...               | 3                  | 2                 | apple          | fish          |
      | Lightfoot | comedian   | 15              | 0       | 1             | dad          | insert dad joke here | 1                  | 5                 | orange         | apple         |

    Given the following inventory table exists:
      | item   | character | quantity |
      | apple  | Stella    | 12       |
      | orange | Ritchey   | 1        |
      | bread  | Lightfoot | 1        |

  Scenario Outline: The trade page should show the non-player's inventory
    Given I am on the trade page for "<person>"
    Then I should see "<item>"

    Examples:
      | person    | item   |
      | Ritchey   | orange |
      | Lightfoot | bread  |

  Scenario: Non-player will always accept a trade for an item they have
    Given I am on the trade page for "Lightfoot"
    When I select "apple" in "I give" dropdown
    * I select "bread" in "I want" dropdown
    * I fill in the number of items that I give with "10"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Success!"