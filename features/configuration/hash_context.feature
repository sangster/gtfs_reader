Feature: Using a Hash Context

  Using a parser block, the user may want to inspect the column of other cells
  in the given row, so we execute their block within the context of an object
  which returns cell values when sent the column name as a method.

  Scenario Outline: Referencing an existing column
    Given a hash of {a: 1, b:2, c: 3}
    When I have a method call, context.<key>
    Then respond_to? should return true for it
     And I should receive <value>

    Examples:
      | key | value |
      |  a  |   1   |
      |  b  |   2   |
      |  c  |   3   |

  Scenario: Referencing a missing column
    Given a hash of {a: 1, b:2, c: 3}
    When I have a method call, context.unknown
    Then I should get a KeyError exception

  Scenario: Using a key that can be converted to a symbol
    Given a hash of {"string" => 1, b:2, c: 3}
    When I create a HashContext
    Then I should not get an exception

  Scenario: Using a key that can't be converted to a symbol
    Given a hash of {Object.new => 1, b:2, c: 3}
    When I create a HashContext
    Then I should get a KeyError exception
