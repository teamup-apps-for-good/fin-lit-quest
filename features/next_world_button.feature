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

    Given the following shopping list entries exist:
      | item     | level   | quantity   |
      | apple    | 1       | 2          |
      | orange   | 1       | 2          |
      | wheat    | 1       | 1          |
      | fish     | 1       | 2          |
      | map      | 2       | 1          |

    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |

    And I am logged in as "Stella"

    Given the following inventory entries exist:
      | item    | character | quantity |
      | orange  | Stella    | 5        |
      | apple   | Stella    | 5        |
      | fish    | Stella    | 2        |

    And I am on the shopping list page

  Scenario: The player cannot proceed to the next level when they do not have all the items on the list
    When I click on "Launch"
    Then I should see "You have not completed the shopping list!"

  Scenario: The player can proceed to the next level when they have all the items on the list
    When "Stella" is given "1" "wheat"
    And I click on "Launch"
    Then I should see "Town 2"
