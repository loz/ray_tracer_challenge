Feature: Tuples

Scenario: A tuple with w=1.0 is a point
  Given a <- tuple:4.3, -4.2, 3.1, 1.0
  Then a.x = 4.3
    And a.y = -4.2
    And a.z = 3.1
    And a is a point
    And a is not a vector

Scenario: A tuple with w=0.0 is a vector
  Given a <- tuple:4.3, -4.2, 3.1, 0.0
  Then a.x = 4.3
    And a.y = -4.2
    And a.z = 3.1
    And a is not a point
    And a is a vector

Scenario: Adding two tuples
  Given a1 <- tuple:3.0, -2.0, 5.0, 1.0
  And a2 <- tuple:-2.0, 3.0, 1.0, 0.0
  Then a1 + a2 = tuple:1.0, 1.0, 6.0, 1.0
