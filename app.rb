require 'bundler/setup'
require 'sinatra'
require_relative './lib/makersacademy/sudoku'

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
    puzzle[index] = ""
  end
  puzzle
end

get '/' do
  session[:solution] = random_sudoku
  session[:puzzle] = puzzle(session[:solution])
  @current_solution = session[:puzzle]
  erb :index
end

get '/solution' do
  @current_solution = session[:solution]
  erb :index
end