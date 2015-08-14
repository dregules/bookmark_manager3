require './app/controllers/base'
require './app/controllers/link'
require './app/controllers/user'
require './app/controllers/sessions'

module BookmarkManager
  class App < Sinatra::Base
    use Routes::Xlink
    use Routes::Xuser
    use Routes::Xsessions
  end
end