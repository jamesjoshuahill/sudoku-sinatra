require 'bundler/setup'
require 'sinatra'
require 'sinatra/partial'
require 'rack-flash'
require_relative './lib/grid'
require_relative './helpers/application'

enable :sessions
set :session_secret, "I'm the secret key to sign the cookie"
set :partial_template_engine, :erb
use Rack::Flash

def random_sudoku
  seed = (1..9).to_a.sample(9).join + ('0' * 72)
  sudoku = Grid.new(seed)
  sudoku.solve
  sudoku.to_s_boxes.chars
end

def puzzle(sudoku)
  puzzle = sudoku.dup
  random_indices = (0..80).to_a.sample(50)
  random_indices.each do |index|
    puzzle[index] = 0
  end
  puzzle
end

def generate_new_puzzle_if_necessary
  return if session[:current_solution]
  new_sudoku = random_sudoku
  session[:solution] = new_sudoku
  session[:current_solution] = session[:puzzle] = puzzle(new_sudoku)
end

def prepare_to_check_solution
  @check_solution = session[:check_solution]
  flash[:notice] = "Wrong numbers are highlighted yellow" if @check_solution
  session[:check_solution] = nil
end

get '/' do
  prepare_to_check_solution
  generate_new_puzzle_if_necessary
  @current_solution = session[:current_solution]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  erb :index
end

post '/' do
  cells = params[:cell]
  session[:current_solution] = cells.map(&:to_i).join
  session[:check_solution] = true
  redirect to '/'
end

get '/solution' do
  redirect to '/' if !session[:current_solution]

  @current_solution = session[:solution]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  flash[:notice] = "Here is the solution"
  erb :index
end

get '/new_puzzle' do
  session[:solution] = session[:puzzle] = session[:current_solution] = session[:check_solution] = nil
  flash[:notice] = "Here is a new puzzle"
  redirect to '/'
end

get '/restart_puzzle' do
  session[:current_solution] = session[:puzzle]
  flash[:notice] = "Restarted the puzzle"
  redirect to '/'
end