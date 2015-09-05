require "./song"

lyrics = "Some really cool words here..."

(1..10).each do |number|

	song = Song.new

	song.title = "Song " + number.to_s
	song.artist = "Artist " + number.to_s
	song.video_link = "Link " + number.to_s
	song.length = rand(10) + rand
	song.released_on = rand(2015).to_s	#since it it changed to date object in song.rb
	song.lyrics = lyrics
	song.save
end
