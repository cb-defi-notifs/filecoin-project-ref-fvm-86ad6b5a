@wip
Feature: RecursiveCall

  Scenario: Single DELEGATECALL modifies caller state
    Given 1 random account
    When account 1 creates 2 RecursiveCall contracts
    And account 1 calls recurse on contract 1 with max depth 1 and contract addresses:
      | addresses  | actions      |
      | contract 2 | DELEGATECALL |
    Then the state of depth and sender of the contracts are:
      | contract   | depth | sender                                     |
      | contract 1 | 1     | account 1                                  |
      | contract 2 | 0     | 0x0000000000000000000000000000000000000000 |


  Scenario: Single CALL modifies callee state
    Given 1 random account
    When account 1 creates 2 RecursiveCall contracts
    And account 1 calls recurse on contract 1 with max depth 1 and contract addresses:
      | addresses  | actions |
      | contract 2 | CALL    |
    Then the state of depth and sender of the contracts are:
      | contract   | depth | sender     |
      | contract 1 | 0     | account 1  |
      | contract 2 | 1     | contract 1 |


  Scenario: Multiple DELEGATECALL modifies caller state
    Given 1 random account
    When account 1 creates 4 RecursiveCall contracts
    And account 1 calls recurse on contract 4 with max depth 5 and contract addresses:
      | addresses  |
      | contract 3 |
      | contract 2 |
      | contract 1 |
      | contract 2 |
      | contract 3 |
    Then the state of depth and sender of the contracts are:
      | contract   | depth | sender    |
      | contract 1 | 0     |           |
      | contract 2 | 0     |           |
      | contract 3 | 0     |           |
      | contract 4 | 5     | account 1 |


  Scenario: Multiple CALL modifies callee state
    Given 1 random account
    When account 1 creates 4 RecursiveCall contracts
    And account 1 calls recurse on contract 4 with max depth 5 and contract addresses:
      | addresses  | actions |
      | contract 3 | CALL    |
      | contract 2 | CALL    |
      | contract 1 | CALL    |
      | contract 2 | CALL    |
      | contract 3 | CALL    |
    Then the state of depth and sender of the contracts are:
      | contract   | depth | sender     |
      | contract 1 | 3     | contract 2 |
      | contract 2 | 4     | contract 1 |
      | contract 3 | 5     | contract 2 |
      | contract 4 | 0     | account 1  |


  Scenario: Mixed CALL/DELEGATECALL
    Given 1 random account
    When account 1 creates 5 RecursiveCall contracts
    And account 1 calls recurse on contract 1 with max depth 4 and contract addresses:
      | addresses  | actions      |
      | contract 2 | DELEGATECALL |
      | contract 3 | CALL         |
      | contract 4 | DELEGATECALL |
      | contract 5 | CALL         |
    Then the state of depth and sender of the contracts are:
      | contract   | depth | sender     |
      | contract 1 | 1     | account 1  |
      | contract 2 | 0     |            |
      | contract 3 | 3     | contract 1 |
      | contract 4 | 0     |            |
      | contract 5 | 4     | contract 3 |


  Scenario: Deep self-recursion with DELEGATECALL
    Given 1 random account
    When account 1 creates 2 RecursiveCall contracts
    And account 1 calls recurse on contract 1 with max depth 100 and contract addresses:
      | addresses  |
      | contract 2 |
    Then the state of depth and sender of the contracts are:
      | contract   | depth | sender    |
      | contract 1 | 100   | account 1 |
      | contract 2 | 0     |           |


  Scenario: Deep self-recursion with CALL
    Given 1 random account
    When account 1 creates 1 RecursiveCall contracts
    And account 1 calls recurse on contract 1 with max depth 100 and contract addresses:
      | addresses  | actions |
      | contract 1 | CALL    |
    Then the state of depth and sender of the contracts are:
      | contract   | depth | sender     |
      | contract 1 | 100   | contract 1 |
