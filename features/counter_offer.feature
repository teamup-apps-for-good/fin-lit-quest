Feature: Make a counter offer to Non-players
  As a player
  so that I can get a better deal
  I want to counter offer the npc with my own items and quantity

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
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |

    Given I am logged in as "Stella"

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
      | bread  | Lightfoot | 0        |
      | fish   | Alice     | 2        |


  Scenario: Player can enter the trade details
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "orange" from the "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Success!"

  Scenario: Player cannot continue without entering all trade details
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "orange" from the "I want" dropdown
    * I fill in the number of items that I give with "2"
    And I press the "Offer" button
    Then I should see a notice of "Please fill in all required fields"

  Scenario: Non-player will accept the trade if the values are worth it
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "orange" from the "I want" dropdown
    * I fill in the number of items that I give with "3"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Success!"

  Scenario: Non-player will not accept trade if it is not worth it for them
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "map" from the "I want" dropdown
    * I fill in the number of items that I give with "1"
    * I fill in the number of items that I want with "1"
    And I press the "Offer" button
    Then I should see a notice of "Ritchey did not accept your offer!"

  Scenario: Non-player will not accept trade if they do not have enough of the item
    Given I am on the counter offer page for "Lightfoot"
    When I select "apple" from the "I give" dropdown
    * I select "bread" from the "I want" dropdown
    * I fill in the number of items that I give with "5"
    * I fill in the number of items that I want with "1"
    And I press the "Offer" button
    Then I should see a notice of "Lightfoot does not have the item you are trying to get"

  Scenario: Player can see item being given being reduced in a successful trade
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "wheat" from the "I want" dropdown
    * I fill in the number of items that I give with "5"
    * I fill in the number of items that I want with "1"
    And I press the "Offer" button
    Then I should see the player owns "0" of "apple"

  Scenario: Player can see item being wanted increasing in a successful trade
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "wheat" from the "I want" dropdown
    * I fill in the number of items that I give with "5"
    * I fill in the number of items that I want with "1"
    And I press the "Offer" button
    Then I should see the player owns "1" of "wheat"

  Scenario: Non-player's inventory quantities change when trade goes through
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "wheat" from the "I want" dropdown
    * I fill in the number of items that I give with "5"
    * I fill in the number of items that I want with "1"
    And I press the "Offer" button
    Then I should see the NPC owns "2" of "wheat"
    And I should see the NPC owns "5" of "apple"

  Scenario: Player can see inventory quantities does not change when trade does not go through
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "wheat" from the "I want" dropdown
    * I fill in the number of items that I give with "1"
    * I fill in the number of items that I want with "5"
    And I press the "Offer" button
    Then I should see the player owns "5" of "apple"

  Scenario: Non-player's inventory quantities does not change when the trade does not go through
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "wheat" from the "I want" dropdown
    * I fill in the number of items that I give with "1"
    * I fill in the number of items that I want with "5"
    And I press the "Offer" button
    Then I should see the NPC owns "3" of "wheat"