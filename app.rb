require 'bundler/setup'
require 'sinatra'
require_relative './lib/makersacademy/sudoku'
require_relative './helpers/application'

enable :sessions

def random_sudoku
  seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
  sudoku = Sudoku.new(seed.join)
  sudoku.solve!
  sudoku.to_s.chars
end

def puzzle(sudoku)
  puzzle = sudoku.dup
  random_indices = (0..81).to_a.sample(40)
  random_indices.each do |index|
    puzzle[index] = 0
  end
  puzzle
end

def generate_new_puzzle_if_necessary
  return if session[:current_solution]
  new_sudoku = random_sudoku
  session[:solution] = new_sudoku
  session[:puzzle] = puzzle(new_sudoku)
  session[:current_solution] = session[:puzzle]
end

def prepare_to_check_solution
  @check_solution = session[:check_solution]
  session[:check_solution] = nil
end

get '/' do
  prepare_to_check_solution
  generate_new_puzzle_if_necessary
  @current_solution = session[:current_solution] || session[:puzzle]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  erb :index
end

post '/' do
  cells = params[:cell]
  session[:current_solution] = cells.map { |value| value.to_i }.join
  session[:check_solution] = true
  redirect to '/'
end

get '/solution' do
  @current_solution = session[:solution]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  erb :index
end

get '/reset' do
  session[:solution] = session[:puzzle] = session[:current_solution] = session[:check_solution] = nil
  redirect to '/'
end