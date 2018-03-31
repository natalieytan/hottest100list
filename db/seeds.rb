require 'json'

file = File.read('triplej.json')
songs = JSON.parse(file)

songs.each do |song|
    Song.create(song)
end