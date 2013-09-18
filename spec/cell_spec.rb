require 'cell'

describe Cell do
  let(:cell) { Cell.new(0) }

  it 'should have a value' do
    expect(cell.value).to eq 0
    cell = Cell.new(1)
    expect(cell.value).to eq 1
  end

  it 'should know it has been filled' do
    cell = Cell.new(5)
    expect(cell).to be_filled_out
  end

  it 'should know if it has not been filled out' do
    expect(cell).not_to be_filled_out
  end

  it 'should be able to assume a value' do
    cell.assume 5
    expect(cell.value).to eq 5
  end

  context 'can have neighbours and' do
    it 'should start with none' do
      cell = Cell.new(0)
      expect(cell.neighbours).to be_empty
    end

    it 'should add neighbours' do
      neighbour = Cell.new(1)
      cell.add_neighbours([neighbour])
      expect(cell.neighbours).to include neighbour
    end

    it 'should not add a neighbour twice' do
      neighbour = double :Cell
      neighbours = [neighbour, neighbour]
      cell.add_neighbours(neighbours)
      expect(cell.neighbours).to eq [neighbour]
    end

    it 'should know the values of it\'s neighbours' do
      neighbours = [Cell.new(1), Cell.new(5), Cell.new(10)]
      cell.add_neighbours(neighbours)
      expect(cell.values_of_neighbours).to eq [1, 5, 10]
    end
  end

  context 'when it has not been filled out' do
    it 'should know which values are possible' do
      expect(cell).to receive(:values_of_neighbours).and_return [1, 2, 3, 4]
      expect(cell.possible_values).to eq [5, 6, 7, 8, 9]

      expect(cell).to receive(:values_of_neighbours).and_return [5, 6, 7, 8, 9]
      expect(cell.possible_values).to eq [1, 2, 3, 4]
    end

    it 'should solve itself if there is only one possible value' do
      expect(cell).to receive(:possible_values).twice.and_return [5]
      cell.solve
      expect(cell.value).to eq 5

      cell = Cell.new(0)
      expect(cell).to receive(:possible_values).twice.and_return [3]
      cell.solve
      expect(cell.value).to eq 3
    end

    it 'should not solve itself if there is more than one possible value' do
      expect(cell).to receive(:possible_values).and_return [1, 2, 3]
      cell.solve
      expect(cell).not_to be_filled_out
    end
  end

  context 'when it has been filled out' do
    it 'should not solve itself' do
      cell = Cell.new(5)
      cell.add_neighbours([1, 2, 3, 4, 5, 6, 7, 8])
      cell.solve
      expect(cell.value).to eq 5
    end
  end
end