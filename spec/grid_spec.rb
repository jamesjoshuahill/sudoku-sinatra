require 'grid'

describe Grid do
  let(:puzzle) { '015003002000100906270068430490002017501040380003905000900081040860070025037204600' }
  let(:grid) { Grid.new(puzzle) }
  let(:hard_puzzle) { (1..9).to_a.sample(9).join + ('0' * 72) }
  let(:hard_grid) { Grid.new(hard_puzzle) }

  it 'should have 9 rows' do
    expect(grid.cells.length).to eq 9
  end

  it 'should have 9 columns' do
    expect(grid.cells.transpose.length).to eq 9
  end

  it 'should create a grid of cells from a puzzle' do
    expect(grid.cells[0][0].value).to eq 0
    expect(grid.cells[0][2].value).to eq 5
  end

  it 'should return a string of the grid' do
    expect(grid.to_s).to eq puzzle
  end

  it 'should display the grid' do
    expect(grid.inspect).to be_a String
    expect(grid.inspect).not_to include '#<Cell:'
    puts grid.inspect
  end

  # Integration test relying on Cell!
  it 'should tell a row of cells they are neighbours' do
    grid.make_neighbours_in_row(0)
    expect(grid.cells[0][0].neighbours.count).to eq 8
  end

  # Integration test relying on Cell!
  it 'should tell a column of cells they are neighbours' do
    grid.make_neighbours_in_column(0)
    expect(grid.cells[0][0].neighbours.count).to eq 8
  end

  # Integration test relying on Cell!
  it 'should tell a box of cells they are neighbours' do
    grid.make_neighbours_in_box(0)
    expect(grid.cells[0][0].neighbours.count).to eq 8

    grid.make_neighbours_in_box(4)
    expect(grid.cells[4][4].neighbours.count).to eq 8
  end

  it 'should tell every cell in the grid it\'s neighbours' do
    grid.make_all_neighbours
    expect(grid.cells[0][0].neighbours.count).to eq 20
    expect(grid.cells[4][4].neighbours.count).to eq 20
    expect(grid.cells[8][8].neighbours.count).to eq 20
  end

  it 'should know it has not been solved' do
    expect(grid).not_to be_solved
  end

  it 'should know if it has been solved' do
    grid = Grid.new('1' * 81)
    expect(grid).to be_solved
  end

  it 'should solve easy puzzles' do
    grid.solve
    expect(grid).to be_solved
  end

  it 'should not try harder to solve easy puzzles' do
    expect(grid).not_to receive :try_harder
    grid.solve
  end

  it 'should list the cells that have not been solved' do
    expect(grid.cells_not_solved.count).to eq 41
    expect(grid.cells_not_solved).to include grid.cells[0][0]
  end

  it 'should try harder to solve hard puzzles' do
    expect(hard_grid).to receive :try_harder
    hard_grid.solve
  end

  it 'should solve hard puzzles' do
    hard_grid.solve
    expect(hard_grid).to be_solved
  end
end