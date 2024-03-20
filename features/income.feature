Feature: get a weekly allowance
  As a player
  So that I can get the understanding of my job
  I want a weekly item after my expenses are paid

  Background:
    Given the following items exist:
      | name   | description                                        | value |
      | apple  | crunchy, fresh from the tree                       | 2     |
      | wheat  | grainy, fresh from the field                       | 1     |

    Given the following players exist:
      | name          | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email          |
      | World1User    | farmer      |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com  |
      | World2User    | farmer      |        5        | 0       |       2         | 5678 | google_oauth2 | test2@test.com |

    Given the following inventory entries exist:
      | item    | character  | quantity |
      | apple   | World1User | 5        |
      | apple   | World2User | 5        |

    Given the following allowance entries exist:
      | level    | item  | quantity |
      | 1        | wheat | 10       |
      | 2        | -     | 10       |

  Scenario: Moving to a new week gives the player 10 wheat on world 1
    Given I am logged in as "World1User"
    And I am on the home page
    And "World1User" is on Day "7" and Hour "9"
    When I click on "Next day"
    Then "World1User" should have "10" "wheat" in their inventory

  Scenario: Moving to a new week gives the player $10 on world 2
    Given I am logged in as "World2User"
    And I am on the home page
    And "World2User" is on Day "7" and Hour "9"
    When I click on "Next day"
    Then "World2User" should have "10" balance

  Scenario: Moving to a new day that's not a new week does not give the player new items
    Given I am logged in as "World1User"
    And I am on the home page
    And "World1User" is on Day "5" and Hour "9"
    When I click on "Next day"
    Then "World1User" should have "0" "wheat" in their inventory

  Scenario: Moving to a new day that's not a new week does not give the player new currency
    Given I am logged in as "World2User"
    And I am on the home page
    And "World2User" is on Day "5" and Hour "9"
    When I click on "Next day"
    Then "World2User" should have "0" balance
