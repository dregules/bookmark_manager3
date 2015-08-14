require_relative 'base'

module BookmarkManager
  module Routes
    class Xuser < Base

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

    end
  end
end