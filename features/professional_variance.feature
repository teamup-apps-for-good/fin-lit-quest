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
      | name   | occupation | inventory_slots | balance | current_level |
      | Stella | programmer | 5               | 0       | 1             |

    Given the following non-players exist:
      | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey   | merchant   | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |
      | Alice     | fisherman  | 15              | 0       | 1             | tired        | zzz...               | 3                  | 2                 | apple          | fish          |

    Given the following inventory entries exist:
      | item   | character | quantity |
      | apple  | Stella    | 5        |
      | orange | Alice     | 4        |
      | bread  | Ritchey   | 3        |
      | fish   | Stella    | 7        |

    Given the following preference entries exist:
      | item   | occupation | multiplier |
      | bread  | merchant   | 3          |
      | fish   | fisherman  | 2          |

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