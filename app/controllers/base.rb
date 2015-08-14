require 'sinatra'
require 'sinatra/flash'

module BookmarkManager
  module Routes
    class Base < Sinatra::Base
      set :views, proc { File.join(root, '..', 'views') }
      register Sinatra::Flash
      enable :sessions
      set :session_secret, 'super secret'  # makes session play nicely with shotgun
      use Rack::MethodOverride

      helpers do
        def current_user
          @current_user ||= User.get(session[:user_id])
          # N.b: .get is a finder method of datamapper!
        end
      end
      run! if app_file == $0
    end
  end
end