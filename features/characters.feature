Feature: View Character Information
  As a player
  I want to click on characters on the screen
  So that I can know more about a character

  Background:
    Given the following characters exist:
      | is_player    | name      | occupation  | inventory_slots | balance |    level   | personality   | dialogue   |
      | true         | Stella    | farmer      |        5        | 0       |     1      |     -         |     -      |
      | false        | Ritchey   | merchant    |        10       | 0       |     -      | enthusiastic  |   hello    |
      | false        | Lightfoot | comedian    |        15       | 0       |     -      |    dad        |   goodbye  |
 
  Scenario: Verify characters exist
    Given I am on the character page 
    Then I should see "Players"
    And I should see "Non-players"

  Scenario: Verify a player exists
    Given I am on the character page
    When I click on "Players"
    Then I should be on the "Players" page
    And I should see "Stella"

  Scenario: Verify a non-player exists
    Given I am on the character page
    When I click on "Non-players"
    Then I should be on the "Non-players" page
    And I should see "Ritchey"
    And I should see "Lightfoot"

  Scenario: Verify a character has an occupation
    Given I am on the "Player" page for "Stella"
    Then I should see "farmer"

  Scenario: Verify a character has inventory_slots
    Given I am on the "Non-player" page for "Ritchey"
    Then "Ritchey"'s inventory slots should be visible
  
  Scenario: Verify a balance is displayed for a non-player character
    Given I am on the "Non-player" page for "Lightfoot"
    Then I should see that a balance is displayed
    And the balance should be a valid number
  
  Scenario: Verify a non-player has personality
    Given I am on the "Non-player" page for "Lightfoot"
    Then I should see "comedian"

  Scenario: Verify a non-player character has dialogue available
    Given I am on the "Non-player" page for "Ritchey"
    Then I should see dialogue text
