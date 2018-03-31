require 'sinatra'
require 'sinatra/activerecord'
require './config/environment'
require './models'

get '/' do
    @years = Song.select(:year).distinct.order(:year)
    erb :index
end

get '/song/:id' do
    @song = Song.find_by_id(params[:id])
    if @song
        erb :song
    else
        erb :not_found
    end
end

get '/artist/:artist_slug' do
    artist_slug = params[:artist_slug]
    @songs = Song.where(artist_slug: params[:artist_slug])
    if @songs.exists?
        @artist = @songs.first.artist
        erb :artist
    else
        erb :not_found
    end
end

post '/year' do
    if params["selected_year"]
        redirect "year/#{params["selected_year"]}"
    else
        redirect '/'
    end
end

get '/year/:year' do
    @year = params[:year]
    @songs = Song.where(year: params[:year])
    if @songs.exists?
        erb :year
    else
        erb :not_found
    end
end

get '/about' do
    erb :about
end

not_found do
    status 404
    erb :not_found
end
