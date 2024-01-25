Feature: In the new and edit form for nonplayers, select items to accept and offer from dropdowns
  As an admin
  so that I can make a new nonplayer character without knowing the database id of the item
  I want to be able to select the item from a dropdown

  Background:
    Given the following items exist:
    |  name   |                 description                  |  value  |
    |  apple  |   crunchy, fresh from the tree               |    2    |
    |  orange |   juicy, fresh from the tree                 |    3    |

    Given the following non-players exist:
    | name      | occupation | inventory_slots | balance | current_level | personality  | dialogue_content     | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
    | Ritchey   | client     | 10              | 0       | 1             | enthusiastic | Howdy                | 2                  | 3                 | apple          | orange        |

  Scenario: Item is available to select from dropdown in new nonplayer form
    Given I am on the new nonplayer character page
    When I fill in "Name" with "Carl"
    And I fill in "Occupation" with "farmer"
    And I fill in "Inventory slots" with "3"
    And I fill in "Balance" with "1"
    And I fill in "Current level" with "1"
    And I fill in "Personality" with "friendly"
    And I fill in "Dialogue content" with "How do you do"
    And I select "orange" from the "Item to accept" dropdown
    And I fill in "Quantity to accept" with "2"
    And I select "apple" from the "Item to offer" dropdown
    And I fill in "Quantity to offer" with "1"
    And I click on "Create Nonplayer"
    Then I should see "Carl was successfully created."

  Scenario: Item is available to select from dropdown in edit nonplayer form
    Given I am on the "Non-player" page for "Ritchey"
    And I click on "Edit this nonplayer"
    When I select "orange" from the "Item to accept" dropdown
    And I select "apple" from the "Item to offer" dropdown
    And I click on "Update Nonplayer"
    Then I should see "Ritchey was successfully updated."
