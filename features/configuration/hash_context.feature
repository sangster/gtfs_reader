Feature: Using a Hash Context

  Using a parser block, the user may want to inspect the column of other cells
  in the given row, so we execute their block within the context of an object
  which returns cell values when sent the column name as a method.

  Scenario Outline: Referencing an existing column
    Given a hash of {red: 'stop', yellow: 'slow', green: 'go'}
    When I have a method call, stop_sign.<color>
    Then respond_to? should return true for it
     And I should receive <action>

    Examples:
      | color  |  action  |
      |  red   |  'stop'  |
      | yellow |  'slow'  |
      | green  |   'go'   |


  Scenario: Referencing a missing column
    Given a hash of {a: 1, b:2, c: 3}
    When I have a method call, context.unknown
    Then I should receive nil
