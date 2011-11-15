Feature: Timer

  The reason the system exists is to
  keep time for a particular project.

  Scenario:
    Given that I'm a valid user
    When I create a new project
    And start timing it
    Then it will create a running timer
