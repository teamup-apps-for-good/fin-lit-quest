Feature: Shopping list
  As a player
  So that I have an incentive to get items
  I want to have a list of items to acquire as a game objective

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

    Given the following shopping list entries exist:
      | item     | level   | quantity   |
      | apple    | 1       | 2          |
      | orange   | 1       | 2          |
      | wheat    | 1       | 1          |
      | fish     | 1       | 2          |
      | bread    | 1       | 1          |
      | apple    | 2       | 5          |
      | orange   | 2       | 3          |
      | bread    | 2       | 6          |
      | boots    | 2       | 1          |
      | map      | 2       | 1          |

    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |

    And I am logged in as "Stella"

    Given the following inventory entries exist:
      | item    | character | quantity |
      | orange  | Stella    | 5        |
      | apple   | Stella    | 5        |
      | fish    | Stella    | 1        |

    And I am on the shopping list page

  Scenario Outline: The list should be visible to a player of the current level
    Then I should see "<quantity>" "<item>" from world "<world>":

    Examples:
      | item     | quantity   | world   |
      | apple    | 2          | 1       |
      | orange   | 2          | 1       |
      | wheat    | 1          | 1       |
      | fish     | 2          | 1       |
      | bread    | 1          | 1       |

  Scenario Outline: The list of the next level should not be visible to a player of the current level
    Then I should not see "<quantity>" "<item>" from world "<world>":

    Examples:
      | item     | world   | quantity   |
      | apple    | 2       | 5          |
      | orange   | 2       | 3          |
      | bread    | 2       | 6          |
      | boots    | 2       | 1          |
      | map      | 2       | 1          |  

  Scenario Outline: When a player owns an item, it should be marked as complete
    Then I should see "<item>" marked as complete from world "<world>"

    Examples:
      | item    | world   |
      | orange  | 1       |
      | apple   | 1       |

  Scenario Outline: When a player does not own an item, it should be marked as incomplete
    Then I should see "<item>" marked as incomplete from world "<world>"
    Examples:
      | item    | world   |
      | bread   | 1       |
      | wheat   | 1       |
      | fish    | 1       |
      