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

not_found do
	@title = "Not Found | Musical Jukebox"
	erb :not_found
end
