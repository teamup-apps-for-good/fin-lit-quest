Feature: In world 2 onwards, the item values field should be available in player and non-player inventory page
  As a player
  so that I can learn how monetary value influences trades
  I want to see the items' values in my own inventory and the non-player's inventory

  Background:
    Given the following items exist:
      | name  | description                                        | value |
      | apple | crunchy, fresh from the tree                       | 2     |
      | wheat | grainy, fresh from the field                       | 1     |
      | boots | sturdy and waterproof, fresh from the cobbler      | 25    |
      | map   | detailed and reliable, fresh from the cartographer | 15    |

    Given the following players exist:
      | name   | occupation | inventory_slots | balance | current_level |
      | Stella | programmer | 5               | 0       | 2             |

    Given the following non-players exist:
      | name    | occupation | inventory_slots | balance | current_level | personality  | dialogue_content | quantity_to_accept | quantity_to_offer | item_to_accept | item_to_offer |
      | Ritchey | client     | 10              | 0       | 2             | enthusiastic | Howdy            | 2                  | 3                 | apple          | wheat         |

    Given the following inventory table exists:
      | item  | character | quantity |
      | apple | Stella    | 5        |
      | boots | Stella    | 0        |
      | wheat | Ritchey   | 3        |
      | boots | Ritchey   | 2        |
      | map   | Ritchey   | 1        |

  Scenario Outline: Player can see the value of items in their own inventory
    Given I am on the inventory page
    Then for "<item>" I should see the "Quantity" is "<value>"

    Examples:
      | item  | value |
      | apple | 2     |
      | boots | 25    |

  Scenario Outline: Player can see the value of items in non-player's inventory
    Given I am on the inventory page for "Ritchey"
    Then for "<item>" I should see the "Quantity" is "<value>"

    Examples:
      | item  | value |
      | wheat | 1     |
      | boots | 25    |
      | map   | 15    |