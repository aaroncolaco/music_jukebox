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

# To re-initialize the DB, uncomment this line. Need to have the adapter
# to run DataMapper.auto_migrate!
# DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

DataMapper.finalize
