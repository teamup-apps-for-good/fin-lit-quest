Feature: Daily Expenses
  As a player
  so that I have motivation to get items
  I want want to have daily expenses

  Background:
    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | day | hour |
      | Stella    | programmer  |        5        | 0       |       1         | 1   | 1    |

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
      | frequency     | number      | item   | quantity |
      | day           | 1           | apple  | 1        |
      | day           | 2           | orange | 2        |

    And the following inventory entries exist:
      | item    | character | quantity |
      | apple   | Stella    | 1        |

  Scenario Outline: The home page shows what cost is required at the end of the day
    Given I am on the home page
    And "Stella" is on Day "<day>" and Hour "<hour>"
    Then I should see "Expenses for today: <quantity> <item>"

    Examples:
      | day | hour | quantity | item   |
      | 1   | 1    | 1        | apple  |
      | 1   | 2    | 1        | apple  |
      | 2   | 2    | 2        | orange |

  Scenario: The player can move to the next day if they can pay their expenses
    Given I am on the home page
    When I click on "Move to the next day"
    Then "Stella" should be on Day "2" and Hour "1"
    And I should see "8:00 on Day 2, Era 1"

  Scenario: The player cannot move to the next day if they can't pay their expenses
    Given "Stella" is on Day "2" and Hour "1"
    And I am on the home page
    When I click on "Move to the next day"
    Then I should see a notice of "You can't afford to pay your expenses yet!"
