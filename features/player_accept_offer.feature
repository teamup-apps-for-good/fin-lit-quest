Feature: Player accept an offer from an non-player
  As a player
  so that I can work towards getting the items I want
  I want to be able to accept a trade offer from an npc

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
      | name   | occupation | inventory_slots | balance | current_level |
      | Stella | programmer | 5               | 0       | 1             |

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
      | Alice     | fisherman  | 15              | 0       | 1             | tired        | zzz...               | 3                  | 2                 | apple          | fish          |
      | Lightfoot | comedian   | 15              | 0       | 1             | dad          | insert dad joke here | 1                  | 5                 | orange         | apple         |

    Given the following inventory entries exist:
      | item   | character | quantity |
      | apple  | Stella    | 5        |
      | orange | Ritchey   | 4        |
      | wheat  | Ritchey   | 3        |
      | boots  | Lightfoot | 2        |
      | map    | Lightfoot | 1        |
      | fish   | Stella    | 0        |

  Scenario: Accepting a valid offer redirects the player to profile
    Given I am on the trade page for "Ritchey"
    When I click on "Yes"
    Then I should be on the profile page for "Ritchey"

  Scenario: Accepting a valid offer gives a notice
    Given I am on the trade page for "Ritchey"
    When I click on "Yes"
    Then I should see a notice of "Success!"

  Scenario: Player inventory should change after successful trade
    Given I am on the trade page for "Ritchey"
    When I click on "Yes"
    Then "Stella" should own "3" of "apple"

  Scenario: Non-player inventory should change after successful trade
    Given I am on the trade page for "Ritchey"
    When I click on "Yes"
    Then "Ritchey" should own "1" of "orange"

  Scenario: Player should not be able to accept an offer for items they do not have
    Given I am on the trade page for "Lightfoot"
    Then I should see "You do not have sufficient items to trade"
    And I should not see "Yes"

  Scenario: Non-player should not be able to offer items they do not have
    Given I am on the trade page for "Alice"
    Then I should see "This character has ran out of fish"