Feature: Play Sudoku
  In order to play sudoku
  As a visitor
  I want to a sudoku puzzle to complete

Scenario: See a sudoku puzzle
  Given I am on the homepage
  Then I should see a puzzle

Scenario: Make guesses
  Given I am on the homepage
  When I fill in an empty square with '1'
  Then the empty square should contain '1'