require 'sinatra' #was sinatra/base
require 'sinatra/flash'

require './app/controllers/base'
require './app/controllers/link'

require_relative 'data_mapper_setup'
require_relative 'models/link'


module BookmarkManager
  #module Routes
    class App < Sinatra::Base

      register Sinatra::Flash
      enable :sessions
      set :session_secret, 'super secret'  # makes session play nicely with shotgun
      use Rack::MethodOverride
      use Routes::Xlink

      helpers do
        def current_user
          @current_user ||= User.get(session[:user_id])
          # N.b: .get is a finder method of datamapper!
        end
      end

      get '/' do
        redirect('/links')
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

      # get '/tags/:name' do
      #   tag = Tag.first(name: params[:name])
      #   @links = tag ? tag.links : []
      #   erb :'links/index'
      # end

      get '/users/new' do
        @user = User.new
        erb :'users/new'
      end

      post '/users' do
        @user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
        if @user.save
          session[:user_id] = @user.id
          redirect to('/links')
        elsif @user.email =~ /\s/ || @user.email == ""
          redirect to('/users/new')
        else
          flash.now[:errors] = @user.errors.full_messages
          erb :'users/new'
        end
      end

      post '/sessions' do
        user = User.authenticate(params[:email], params[:password])
        if user
          session[:user_id] = user.id
          redirect '/links'
        else
          flash[:errors] = ['Password and/or email incorrect']
          erb :'sessions/new'
        end
      end

      get '/sessions/new' do
        erb :'sessions/new'
      end

      delete '/sessions' do
        session[:user_id] = nil
        flash[:ciao] = 'goodbye!'
      end

      # start the server if ruby file executed directly
      run! if app_file == $0
    end
  #end
end