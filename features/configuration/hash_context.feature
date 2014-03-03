Feature: Using a Hash Context

  Using a parser block, the user may want to inspect the column of other cells
  in the given row, so we execute their block within the context of an object
  which returns cell values when sent the column name as a method.

  Scenario: Referencing a column
    Given a hash of {a: 1, b:2, c: 3}
    When I call context.a
    Then I should receive 1
