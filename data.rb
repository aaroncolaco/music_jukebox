# To populate DB with fake songs

require "./song"

lyrics = "Some really cool words here..."

(1..10).each do |number|

	song = Song.new

	song.title = "Song " + number.to_s
	song.artist = "Artist " + number.to_s
	song.video_link = "https://www.youtube.com/watch?v=nWuZMBtrc1E"
	song.length = rand(10) + rand
	song.released_on = rand(2015).to_s	#since it changed to date object in song.rb
	song.lyrics = lyrics
	song.save

	# To delete the songs
	# song = Song.last
	# song.destroy
end
