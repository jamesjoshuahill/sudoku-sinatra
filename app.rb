require 'bundler/setup'
require 'sinatra'

get '/' do # default route for our website
  "Hello, sudoku"
end