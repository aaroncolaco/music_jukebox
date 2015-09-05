require 'sinatra'
require "./song"

# Reload if in development mode
require 'sinatra/reloader' if development?

get '/' do
	@title = "Musical Jukebox"
	erb :home
end

get '/about' do
	@title = "About | Musical Jukebox"
	erb :about
end

get '/contact' do
	@title = "Contact | Musical Jukebox"
	erb :contact
end

get '/songs/new' do
	@song = Song.new
	erb :new_song
end

get '/songs/:id' do
	@song = Song.get(params[:id])
	erb :show_song
end

post '/songs' do
	song = Song.create(params[:song])
	redirect to("/songs/#{song.id}")
end

not_found do
	@title = "Not Found | Musical Jukebox"
	erb :not_found
end
