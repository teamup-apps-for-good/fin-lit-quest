Feature: Time advancement
  As a player
  so that I have motivation to progress
  I want time to progress as I take actions

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

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
      | Alice     | fisherman  | 15              | 0       | 1             | tired        | zzz...               | 3                  | 2                 | apple          | fish          |
      | Lightfoot | comedian   | 15              | 0       | 1             | dad          | insert dad joke here | 1                  | 5                 | orange         | apple         |

    Given the following inventory entries exist:
      | item    | character | quantity |
      | orange  | Ritchey   | 4        |
      | wheat   | Ritchey   | 3        |
      | boots   | Lightfoot | 2        |
      | map     | Lightfoot | 1        |
      | bread   | Lightfoot | 0        |
      | fish    | Alice     | 2        |  
      | orange  | Stella    | 5        |
      | apple   | Stella    | 5        |
      | fish    | Stella    | 2        |

    Given the following shopping list entries exist:
      | item     | level   | quantity   |
      | apple    | 1       | 2          |
      | orange   | 1       | 2          |
      | wheat    | 1       | 1          |
      | fish     | 1       | 2          |
      | map      | 2       | 1          |

    Given I am logged in as "Stella"

  Scenario: The home page displays the current time
    Given I am on the home page
    And "Stella" is on Day "1" and Hour "1"
    Then I should see "8:00 AM on Day 1, Era 1"

  Scenario: Taking an action moves time forward
    Given I am on the counter offer page for "Ritchey"
    And "Stella" is on Day "1" and Hour "1"
    When I select "apple" from the "I give" dropdown
    * I select "orange" from the "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then "Stella" should be on Day "1" and Hour "2"

  Scenario: Actions cannot be taken when it is too late in the day
    Given I am on the counter offer page for "Ritchey"
    And "Stella" is on Day "1" and Hour "10"
    When I select "apple" from the "I give" dropdown
    * I select "orange" from the "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then  I should see a notice of "It is too late! Move to the next day"

  Scenario: The player can move to the next day
    Given I am on the home page
    And "Stella" is on Day "1" and Hour "9"
    When I click on "Next day"
    Then "Stella" should be on Day "2" and Hour "1"
    And I should see "8:00 AM on Day 2, Era 1"

  Scenario: The when the player moves to the next phase, the time restarts
    Given I am on the shopping list page
    And "Stella" is on Day "5" and Hour "10"
    When "Stella" is given "1" "wheat"
    And I click on "Launch"
    Then I should see "8:00 AM on Day 1, Era 2"