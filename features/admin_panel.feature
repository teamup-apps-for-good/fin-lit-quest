Feature: admin panel
  As an admin
  So that I can moderate and edit the details of the game
  I would like to have exclusive access to an admin panel

  Background:
    Given the following players exist:
      | name   | occupation | inventory_slots | balance | current_level | uid  | provider      | email         | admin |
      | Stella | admin      | 5               | 0       | 1             | 1234 | google_oauth2 | test@test.com | true  |
      | Alice  | programmer | 5               | 0       | 1             | 1235 | google_oauth2 | test@test.com | false |

  Scenario Outline: Only admin can see the admin panel button
    Given I am logged in as "<name>"
    And I am on the home page
    Then I should <message>

    Examples:
      | name   | message               |
      | Stella | see "Admin Panel"     |
      | Alice  | not see "Admin Panel" |

  Scenario Outline: Admin can click button to visit admin panel
    Given I am logged in as "Stella"
    And I am on the admin panel page
    When I click on "<button>"
    Then I should be on <path>

    Examples:
      | button         | path                   |
      | Players        | the Players page       |
      | Non Players    | the Non-players page   |
      | Inventories    | the inventories page   |
      | Items          | the items page         |
      | Shopping Lists | the shopping list page |
      | Preferences    | the preferences page   |
      | Expenses       | the expenses page      |

