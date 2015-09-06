require 'dm-core'
require 'dm-migrations'

class Song
	include DataMapper::Resource
	property :id, Serial
	property :title, String
	property :artist, String
	property :video_link, String
	property :length, Integer
	property :released_on, Date
	property :lyrics, Text

	def released_on=date
		super Date.strptime(date, '%Y')
	end
	
end

configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

DataMapper.finalize
