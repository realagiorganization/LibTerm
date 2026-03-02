Feature: LibTerm project fundamentals
  As a contributor
  I want to validate core project assets
  So that builds and documentation remain consistent

  Scenario: Project structure is intact
    Given the repository root is available
    Then the setup script exists
    And the iOS project exists
    And the README mentions the package command
