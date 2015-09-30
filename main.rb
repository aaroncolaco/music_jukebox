require 'sinatra'
require './song'
require 'sinatra/flash'

# Reload if in development mode
require 'sinatra/reloader' if development?

set :app_name, "Musical Jukebox"

configure do
	enable :sessions
	set :username, 'aaron'
	set :password, 'aaron'
end

# for development
configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
	
	disable :show_exceptions   #To show the 'error' page when eroor occurs. Remove 
								# to carry out debugging & restart server
end

# DB for production
configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end

# Gets executed before every request. So this is done to set @title to
# the default -- appname -- using the set_title helper
before do
	set_title
end

get '/' do
	@title = "Home"
	erb :home
end

get '/about' do
	@title = "About"
	erb :about
end

get '/contact' do
	@title = "Contact"
	erb :contact
end

get '/songs' do
	@title = "Songs"
	@songs = Song.all
	erb :songs
end

get '/login' do
	if session[:admin]
		redirect to ("/songs")
	end
	erb :login
end

get '/logout' do
	session.clear
	redirect to('/login')
end

get '/songs/new' do
	# Only works if admin logged in
	halt(401) unless session[:admin]
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

get '/download' do
	erb :download
end

post '/download' do
	redirect to ('/download/download_file.zip')
end

get '/download/:filename' do
	filename = params[:filename]

	# Set :filename & path to the path to the file to download 
	options = {:filename => filename, :type => 'application/zip', :disposition => 'attachment'}
	path = "./public/download_file/#{filename}"
	send_file path, options
end

# Add song
post '/songs' do
	# Need to proted from direct post reqest that someone may try
	# since the form is accessible only to admin
	# Only works if admin logged in
	halt(401) unless session[:admin]

	# To convert the entered time string to seconds instead of xx:xx format:
	# incoming data is in 'song' hash. 
	# create hash 'foo'. Use foo in the create method after formatting the length
	foo = params[:song]
	time = foo[:length].to_s.split(':')
	time = (time.first.to_i * 60 + time.last.to_i)
	foo[:length] = time

	# Setting flash message to display. Uses sinatra-flash gem
	if song = Song.create(foo)
		flash[:notice] = "Song successfully added"
	end
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

	# Setting flash message to display. Uses sinatra-flash gem
	if song.update(foo)
		flash[:notice] = "Song successfully updated"
	end
	redirect to("/songs/#{song.id}")
end

# Delete song
delete '/songs/:id' do
	# Only works if admin logged in
	halt(401) unless session[:admin]
	
	if Song.get(params[:id]).destroy
		flash[:notice] = "Song deleted"
	end
	redirect to('/songs')
end

post '/login' do
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] = true
		redirect to('/songs')
	else
		flash[:notice] = "Incorrect username or password"
		redirect to('/login')
	end
end

# Authentication Error 
error 401 do
	@title = "Not Authorized"
	erb :not_authorized
end

# All errors
error do
	@title = "Error"
	erb :error
end

# Not Found error
not_found do
	@title = "Not Found"
	erb :not_found
end

helpers do
	def current?(path = '/')
		(request.path == path || request.path == path+'/') ? "active" : nil
	end
	def set_title
		# if not given, set to app name. That is why the OR
		@title ||= settings.app_name
		# Done so that we don't have to put this login in the erb file like before
	end
end