require 'sinatra/base'
require_relative 'data_mapper_setup'
require_relative 'models/link'
class App < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'  # i think this is a stub so that the session is always ecrypted the same way

  get '/' do
    erb :'layout'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    tag_names = (params[:tags]).split
    tag_names.each  { |tag| link.tags << Tag.create(name: tag) }
    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect to('/links')
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
      # N.b: .get is a finder method of datamapper!
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
