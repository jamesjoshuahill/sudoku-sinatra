require 'sass/plugin/rack'
require './app'

# use Sass for stylesheets
Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

run Sinatra::Application