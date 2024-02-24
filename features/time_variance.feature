Feature: Time Variance
  As a player
  so that I can have a realistic feeling of trading
  I want there to be a different experience when trading at different times each week.

  Background:
    Given the following items exist:
      | name   | description                                        | value |
      | apple  | crunchy, fresh from the tree                       | 2     |
      | orange | tangy, fresh from the tree                         | 2     |

    Given the following players exist:
    | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
    | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |

    Given I am logged in as "Stella"

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Alice     | fisherman  | 15              | 0       | 1             | tired        | zzz...               | 3                  | 2                 | apple          | orange          |

    Given the following inventory table exists:
      | item   | character | quantity |
      | apple  | Stella    | 5        |
      | orange | Alice     | 4        |

  Scenario: On day 1, orange and apple should be the same price
    Given I am on the counter offer page for "Alice"
    And "Stella" is on Day "1" and Hour "1"
    When I select "apple" in "I give" dropdown
    * I select "orange" in "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Success!"

  Scenario: On day 1 different hour, orange and apple should be the same price
    Given I am on the counter offer page for "Alice"
    And "Stella" is on Day "1" and Hour "5"
    When I select "apple" in "I give" dropdown
    * I select "orange" in "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Success!"

  Scenario: On day 2, orange and apple should not be the same price
    Given I am on the counter offer page for "Alice"
    And "Stella" is on Day "2" and Hour "1"
    When I select "apple" in "I give" dropdown
    * I select "orange" in "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Success, but that wasn't the best deal."

