require_relative 'base'

module BookmarkManager
  module Routes
    class Xsessions < Base

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

    end
  end
end