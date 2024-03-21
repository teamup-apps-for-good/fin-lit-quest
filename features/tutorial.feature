Feature: Tutorial
  As a player
  So that I can quickly get the hang of how the game works and understand what is happening
  I want a brief tutorial

  Background:
    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | Player    | programmer  |        5        | 0       |       1         | 4321 | google_oauth2 | test@test.com |
      | Player2   | programmer  |        5        | 0       |       2         | 5678 | google_oauth2 | test@test.com |

  Scenario: I see the tutorial when I first create an account
    Given I am not logged in
    And I am on the login page
    When I click on "Sign in with Google"
    Then I should be on the tutorial page

  Scenario: I do not see the tutorial page if I already have an account
    Given the following players exist:
      | name      | occupation  | inventory_slots | balance |  current_level  | uid  | provider      | email         |
      | Stella    | programmer  |        5        | 0       |       1         | 1234 | google_oauth2 | test@test.com |
    And I am not logged in
    And I am on the login page
    When I click on "Sign in with Google"
    Then I should be on the home page

  Scenario: The home page has a help button that brings me to the tutorial
    Given I am logged in as "Player"
    And I am on the home page
    When I click on "Help"
    Then I should be on the tutorial page

  Scenario: The tutorial page has a back button that brings me home
    Given I am logged in as "Player"
    And I am on the tutorial page
    When I click on "Back"
    Then I should be on the home page

  Scenario: The tutorial page teaches me how to play the game world 1
    Given I am logged in as "Player"
    And I am on the tutorial page
    Then I should see "Welcome to FinLitQuest!"
    When I click on "Next"
    Then I should see "FinLitQuest is an adventure game designed to educate users on financial literacy, from core concepts such as bartering to debt, investing, and more."
    When I click on "Next"
    Then I should see "Start playing by visiting the town. There, you should find some other townsfolk to trade with and start working towards your shopping list."
    When I click on "Next"
    Then I should see "What's your shopping list you ask? Well, in order to advance to the next world, you first need to acquire some items to buy a rocket ticket with! You can check your shopping list and its progress on your sidebar."
    When I click on "Next"
    Then I should see "Also, I want to remind you that you have expenses such as food as well, so don't forget to keep yourself fed!"
    When I click on "Next"
    Then I should see "Go ahead and start exploring, and I'll see you on world 2!"
    When I click on "Done"
    Then I should be on the home page

  Scenario: The tutorial pages teaches me how to play the game world 2
    Given I am logged in as "Player2"
    And I am on the tutorial page
    Then I should see "Welcome to world 2!"
    When I click on "Next"
    Then I should see "Congratulations on making it past the first world! I hear you are an excellent barterer."
    When I click on "Next"
    Then I should see "On this world, you're going to discover a new tool for trading: currency."
    When I click on "Next"
    Then I should see "Instead of trading item for item, currency introduces a medium that has a value which all parties in a transaction agree on."
    When I click on "Next"
    Then I should see "You'll notice some new options on your trading pages in with other townspeople: the options to buy and sell along with bartering. You'll also have a new indicator for the amount of money you have along with your inventory"
    When I click on "Next"
    Then I should see "When you buy and sell, you'll exchange your money for items or your items for money, respectively. You'll also be able to see the value of your items and the price that your trading partner is selling their items for"
    When I click on "Next"
    Then I should see "So go ahead and start working towards your new rocket ticket, but this time you're going to need to purchase it with currency!"
    When I click on "Done"
    Then I should be on the home page