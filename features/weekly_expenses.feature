Feature: Weekly Expenses
  As a player
  so that I have motivation to get items
  I want to have weekly expenses

  Background:
    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |

    Given the following items exist:
      | name   | description                                        | value |
      | apple  | crunchy, fresh from the tree                       | 2     |
      | orange | tangy, fresh from the tree                         | 2     |
      | wheat  | grainy, fresh from the field                       | 1     |
      | boots  | sturdy and waterproof, fresh from the cobbler      | 25    |
      | map    | detailed and reliable, fresh from the cartographer | 15    |
      | fish   | still floppin' around, fresh from the ocean        | 3     |
      | bread  | yummy, fresh from the oven                         | 2     |

    And the following expenses exist:
      | frequency  | number    | item     | quantity   |
      | week       | 1         | wheat    | 1          |
      | week       | 2         | boots    | 2          |

    And the following inventory entries exist:
      | item    | character | quantity |
      | wheat   | Stella    | 1        |

    And I am logged in as "Stella"

  Scenario Outline: The home page shows what cost is required at the end of the week
    Given "Stella" is on Day "<day>" and Hour "<hour>"
    And  I am on the home page
    Then I should see "Expenses for this week: <quantity> <item>"

    Examples:
      | day | hour | quantity | item   |
      | 1   | 1    | 1        | wheat  |
      | 1   | 2    | 1        | wheat  |
      | 2   | 2    | 1        | wheat  |
      | 8   | 2    | 2        | boots  |

  Scenario: The player can move to the next day if they can pay their expenses
    Given "Stella" is on Day "7" and Hour "3"
    And I am on the home page
    When I click on "Move to the next day"
    And I visit the home page
    Then "Stella" should be on Day "8" and Hour "1"
    And I should see "08:00 AM on Day 8, Era 1"

  Scenario: The player cannot move to the next day if they can't pay their expenses
    Given I am on the home page
    And "Stella" is on Day "14" and Hour "3"
    When I click on "Move to the next day"
    Then I should see a notice of "You can't afford to pay your expenses yet!"
    And "Stella" should be on Day "14" and Hour "3"
