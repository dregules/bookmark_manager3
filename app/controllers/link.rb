require_relative 'base'

module BookmarkManager
  module Routes
    class Xlink < Base

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

      get '/tags/:name' do
        tag = Tag.first(name: params[:name])
        @links = tag ? tag.links : []
        erb :'/links/index'
      end
    end
  end
end

