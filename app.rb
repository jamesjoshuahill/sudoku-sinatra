require 'bundler/setup'
require 'sinatra'
require 'sinatra/partial'
require 'rack-flash'
require 'haml'

require_relative './lib/grid'
require_relative './helpers/application'

enable :sessions
set :session_secret, "I'm the secret key to sign the cookie"
use Rack::Flash

def random_sudoku
  seed = (1..9).to_a.sample(9).join + ('0' * 72)
  sudoku = Grid.new(seed)
  sudoku.solve
  sudoku.to_s_boxes.chars
end

def puzzle(sudoku)
  difficulties = { easy: 35, hard: 55 }
  puzzle = sudoku.dup
  random_indices = (0..80).to_a.sample(difficulties[@difficulty])
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
  session[:check_solution] = nil
end

get '/' do
  prepare_to_check_solution
  if session[:difficulty]
    @difficulty = session[:difficulty]
  else
    @difficulty = session[:difficulty] = :easy
  end
  generate_new_puzzle_if_necessary
  @current_solution = session[:current_solution]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  haml :index
end

post '/' do
  cells = params[:cell]
  session[:current_solution] = cells.map(&:to_i).join
  if params[:check_solution]
    session[:check_solution] = true
    flash[:notice] = "Checked. Any mistakes are highlighted <span class='blue_notice'>blue</span>"
  elsif params[:save_progress]
    flash[:notice] = "Your progress has been saved"
  end
  redirect to '/'
end

get '/solution' do
  redirect to '/' if !session[:current_solution]
  @difficulty = session[:difficulty]
  @current_solution = session[:solution]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  flash[:notice] = "Given up? Here is the solution"
  haml :index
end

get '/new_puzzle' do
  session[:solution] = session[:puzzle] = session[:current_solution] = session[:check_solution] = nil
  if params[:difficulty]
    session[:difficulty] = params[:difficulty].to_sym
  end
  flash[:notice] = "Here's a new #{session[:difficulty]} puzzle. Good luck!"
  redirect to '/'
end

get '/restart_puzzle' do
  session[:current_solution] = session[:puzzle]
  flash[:notice] = "Restarted. Back to the beginning..."
  redirect to '/'
end