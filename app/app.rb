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

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    # Link.create(url: params[:url], title: params[:title])
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


  # start the server if ruby file executed directly
  run! if app_file == $0
end
