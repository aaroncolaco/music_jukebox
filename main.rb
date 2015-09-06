require 'sinatra'
require './song'

# Reload if in development mode
require 'sinatra/reloader' if development?

configure do
	enable :sessions
	set :username, 'aaron'
	set :password, 'aaron'
end

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

get '/songs' do
	@songs = Song.all
	erb :songs
end

get '/songs/new' do
	@song = Song.new
	erb :new_song
end

get '/songs/:id' do
	@song = Song.get(params[:id])
	erb :show_song
end

get '/songs/:id/edit' do
	@song = Song.get(params[:id])
	erb :edit_song
end

# Add song
post '/songs' do
	# To convert the entered time string to seconds instead of xx:xx format:
	# incoming data is in 'song' hash. 
	# create hash 'foo'. Use foo in the update method after formatting the length
	foo = params[:song]
	time = foo[:length].to_s.split(':')
	time = (time.first.to_i * 60 + time.last.to_i)
	foo[:length] = time

	song = Song.create(foo)
	redirect to("/songs/#{song.id}")
end

# Update song
put '/songs/:id' do
	# To convert the entered time string to seconds instead of xx:xx format:
	# incoming data is in 'song' hash. 
	# create hash 'foo'. Use foo in the update method after formatting the length
	foo = params[:song]
	time = foo[:length].to_s.split(':')
	time = (time.first.to_i * 60 + time.last.to_i)
	foo[:length] = time

	song = Song.get(params[:id])
	song.update(foo)
	redirect to("/songs/#{song.id}")
end

# Delete song
delete '/songs/:id' do
	Song.get(params[:id]).destroy
	redirect to('/songs')
end

not_found do
	@title = "Not Found | Musical Jukebox"
	erb :not_found
end
