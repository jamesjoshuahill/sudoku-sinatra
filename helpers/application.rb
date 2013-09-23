module ApplicationHelpers

  def colour_class(cell_index)
    solution_to_check = @check_solution
    puzzle_value = @puzzle[cell_index]
    current_solution_value = @current_solution[cell_index]
    solution_value = @solution[cell_index]

    must_be_guessed = puzzle_value == 0
    tried_to_guess = current_solution_value.to_i != 0
    guessed_incorrectly = current_solution_value != solution_value

    if solution_to_check && 
        must_be_guessed && 
        tried_to_guess && 
        guessed_incorrectly
      'incorrect'
    elsif !must_be_guessed
      'value-provided'
    end
  end

  def cell_value(value)
    value.to_i == 0 ? '' : value
  end

end