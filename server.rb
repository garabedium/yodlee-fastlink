require 'sinatra'
require 'sinatra/reloader'
require 'dotenv/load'
require 'pry'

set :bind, '0.0.0.0'

get '/yodlee-fastlink' do
  @env_test = ENV['TEST_LOREM']
  erb :index
end