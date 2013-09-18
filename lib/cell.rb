class Cell
  attr_reader :value, :neighbours

  def initialize(value)
    @value = value
    @neighbours = []
  end

  def filled_out?
    @value != 0
  end

  def assume(value)
    @value = value
  end

  def add_neighbours(neighbours)
    @neighbours.concat(neighbours)
    @neighbours.uniq!
  end

  def values_of_neighbours
    @neighbours.map(&:value)
  end

  def possible_values
    (1..9).to_a - values_of_neighbours
  end

  def solve
    if not filled_out?
      @value = possible_values.first if possible_values.count == 1
    end
  end
end