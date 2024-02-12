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

    Given the following inventory table exists:
      | item   | character | quantity |
      | apple  | Stella    | 5        |
      | orange | Alice     | 4        |
      | bread  | Ritchey   | 3        |
      | fish   | Stella    | 7        |

    Given the following bias table exists:
      | item   | occupation | bias     |
      | bread  | merchant   | 3        |
      | fish   | fisherman  | 0.75     |

  Scenario: The fisherman will value fish lower
    Given I am on the counter offer page for "Alice"
    When I choose "orange" in "I give" dropdown
    * I choose "fish" in "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Success!"

  Scenario: The client values bread more
    Given I am on the counter offer page for "Ritchey"
    When I choose "apple" in "I give" dropdown
    * I choose "bread" in "I want" dropdown
    * I fill in the number of items that I give with "2"
    * I fill in the number of items that I want with "2"
    And I press the "Offer" button
    Then I should see a notice of "Ritchey did not accept your offer!"