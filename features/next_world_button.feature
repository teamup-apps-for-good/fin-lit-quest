Feature: Shopping list
  As a player
  So that I can progress to a new world
  I want to buy a ticket and see a new scene/town + have new interactions available to me

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

    Given the following shopping list table exists:
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
      | name   | occupation | inventory_slots | balance | current_level |
      | Stella | programmer | 5               | 0       | 1             |
      | Carl   | carrot     | 5               | 0       | 1             |

    Given the following inventory table exists:
      | item    | character | quantity |
      | orange  | Stella    | 5        |
      | apple   | Stella    | 5        |
      | fish    | Stella    | 1        |
      | orange  | Carl      | 2        |
      | apple   | Carl      | 2        |
      | bread   | Carl      | 1        |
      | wheat   | Carl      | 1        |
      | fish   | Carl       | 2        |

    And I am on the shopping list page

  Scenario: The player can proceed to the next level when they have all the items on the list
    When I click on "Launch"
    Then I should see "Town 2"

  Scenario: The player can proceed to the next level when they have do not have all the items on the list
    When I click on "Launch"
    Then I should see "You have not completed the shopping list!"