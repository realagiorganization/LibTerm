Feature: LLM request via CLI in tmux
  As a maintainer
  I want a scripted LLM request to succeed
  So that secret-based integrations are validated in CI

  Scenario: Make an LLM request with encrypted secrets
    Given the LLM request secret is configured
    When I run the tmux LLM request script
    Then a response payload is saved
