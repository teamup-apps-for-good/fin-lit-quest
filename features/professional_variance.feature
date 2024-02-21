Feature: Profession price preference variance
  As a player
  so that I can have a realistic feeling of trading
  I want there to be a different experience when trading with different characters based on mood and profession.

  Background:
    Given the following items exist:
      | name   | description                                        | value |
      | apple  | crunchy, fresh from the tree                       | 2     |
      | orange | tangy, fresh from the tree                         | 2     |
      | fish   | still floppin' around, fresh from the ocean        | 3     |
      | bread  | yummy, fresh from the oven                         | 2     |

    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | merchant   | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
      | Alice     | fisherman  | 15              | 0       | 1             | tired        | zzz...               | 3                  | 2                 | apple          | fish          |
      | Lightfoot | merchant   | 15              | 0       | 1             | dad          | insert dad joke here | 1                  | 5                 | orange         | apple         |
      | Paimon    | food       | 15              | 0       | 1             | annoyin      | can't go there yet   | 1                  | 5                 | bread          | orange        |

    Given the following inventory entries exist:
      | item   | character | quantity |
      | apple  | Stella    | 5        |
      | orange | Alice     | 4        |
      | bread  | Ritchey   | 3        |
      | fish   | Stella    | 7        |

    Given the following preference entries exist:
      | item   | occupation | multiplier | description                                                      |
      | bread  | merchant   | 3          | Grinds wheat into flour and bakes handbaked bread.               |
      | fish   | fisherman  | 2          | Catches fish from the sea daily.                                 |
      | apple  | programmer | 2          | Writes code most of the time, when they are not in meetings.     | 

    Given I am logged in as "Stella"

  Scenario: The fisherman will value fish higher and trade goes through
    Given I am on the counter offer page for "Alice"
    When I select "fish" from the "I give" dropdown
    * I select "orange" from the "I want" dropdown
    * I fill in the number of items that I give with "1"
    * I fill in the number of items that I want with "3"
    And I press the "Offer" button
    Then I should see a notice of "Success!"

  Scenario: The client values bread more and trade does not go through
    Given I am on the counter offer page for "Ritchey"
    When I select "apple" from the "I give" dropdown
    * I select "bread" from the "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Ritchey did not accept your offer!"

  Scenario Outline: All non-players with the same occupation have the same description
    Given I am on the trade page for "<non-player>"
    Then I should see "Grinds wheat into flour and bakes handbaked bread."
    Examples:
        | non-player |
        | Ritchey    |
        | Lightfoot  |

  Scenario Outline: Non-players with different occupations have different descriptions
    Given I am on the trade page for "Alice"
    Then I should see "Catches fish from the sea daily."

  Scenario Outline: The non-player's occupation should not be shown if it is not a preference
    Given I am on the trade page for "Paimon"
    Then I should not see "Occupation Description:"
