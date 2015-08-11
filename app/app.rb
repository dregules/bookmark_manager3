require 'sinatra/base'
require_relative 'data_mapper_setup'
require_relative 'models/link'
class App < Sinatra::Base
  get '/' do
    'Hello App!'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
