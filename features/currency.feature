Feature: Exchange with currency
  As a player
  So that I can learn about the development of currency
  I want to be able to use currency as a means of exchange

  Background:
    Given the following items exist:
      | name   | description                                        | value |
      | apple  | crunchy, fresh from the tree                       | 2     |
      | orange | tangy, fresh from the tree                         | 2     |
      | wheat  | grainy, fresh from the field                       | 1     |
      | boots  | sturdy and waterproof, fresh from the cobbler      | 25    |
      | map    | detailed and reliable, fresh from the cartographer | 15    |
      | fish   | still floppin' around, fresh from the ocean        | 3     |
      | bread  | yummy, fresh from the oven                         | 199     |

    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | World1User    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |
      | World2User    | programmer  |        5        | 0       |       2         | 5678 | google_oauth2 | test@test.com |

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
      | Lightfoot | comedian   | 15              | 0       | 2             | dad          | insert dad joke here | 1                  | 5                 | orange         | apple         |

    Given the following inventory table exists:
      | item   | character | quantity |
      | apple  | World2User| 5        |
      | orange | World2User| 4        |
      | boots  | Lightfoot | 2        |
      | map    | Lightfoot | 1        |
      | bread  | Lightfoot | 1        |
      | bread  | Ritchey   | 1        |


  Scenario: I can choose to buy, sell, or barter
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    Then I should see "Barter"
    And I should see "Buy"
    And I should see "Sell"

  Scenario Outline: The player can see the monetary values and stocks of the NPC's items
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    Then I should see "<item> $<price> - <qty> in stock"

    Examples:
      | item  | price | qty |
      | boots | 25    | 2   |
      | map   | 15    | 1   |
      | bread | 199   | 1   |

  Scenario Outline: The player can see the monetary values of their own items
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    Then I should see "<item> $<price> - <qty> on me"

    Examples:
      | item   | price | qty |
      | apple  | 2     | 5   |
      | orange | 2     | 4   |

  Scenario: I see the correct prompts for purchasing items with money
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    When I click on "Buy"
    Then I should see "I want"
    And I should see "Quantity I want"
    And I should see "Total price: "

  Scenario: I do not see the incorrect prompts for purchasing items with money
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    When I click on "Buy"
    Then I should not see "I give"
    And I should not see "Quantity I give"

  Scenario: I see the correct prompts for selling items for money
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    When I click on "Sell"
    Then I should see "I give"
    And I should see "Quantity I give"
    And I should see "Total price: "

  Scenario: I do not see the incorrect prompts for purchasing items with money
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    When I click on "Sell"
    Then I should not see "I want"
    And I should not see "Quantity I want"

  Scenario: I see the value of items that I want to buy
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    And "World2User" has a balance of "100"
    When I click on "Buy"
    And I select "boots" in "I want" dropdown
    And I fill in the number of items that I want with "2"
    Then I should see "50" in "Total value" field

  Scenario: Purchasing items subtracts money from my inventory
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    And "World2User" has a balance of "100"
    When I click on "Buy"
    And I select "boots" in "I want" dropdown
    And I fill in the number of items that I want with "2"
    And I click on "Purchase"
    Then "World2User" should have a balance of "50"

  Scenario: I cannot purchase items if I do not have enough money
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    And "World2User" has a balance of "100"
    When I click on "Buy"
    And I select "boots" in "I want" dropdown
    And I fill in the number of items that I want with "2"
    And I click on "Purchase"
    Then I should see "You do not have enough money to purchase these item(s)"
    Then "World2User" should have a balance of "100"

  Scenario: Selling items adds money to my inventory
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    And "World2User" has a balance of "0"
    When I click on "Sell"
    And I select "apple" in "I give" dropdown
    And I fill in the number of items that I give with "2"
    And I click on "Sell"
    Then "World2User" should have a balance of "4"

  Scenario: I cannot sell more items than I have
    Given I am logged in as "World2User"
    And "World2User" is on level "2"
    And I am on the trade page for "Lightfoot"
    And "World2User" has a balance of "0"
    When I click on "Sell"
    And I select "apple" in "I give" dropdown
    And I fill in the number of items that I give with "10"
    And I click on "Sell"
    Then I should see "You do not have enough items to sell"
    Then "World2User" should have a balance of "0"

  Scenario: I do not see the option to buy or sell on world 1
    Given I am logged in as "World1User"
    And "World2User" is on level "2"
    And I am on the trade page for "Ritchey"
    Then I should not see "Buy"
    And I should not see "Sell"

  Scenario: I do not see item values on world 1
    Given I am logged in as "World1User"
    And "World1User" is on level "1"
    And I am on the trade page for "Ritchey"
    Then I should not see "\$199"