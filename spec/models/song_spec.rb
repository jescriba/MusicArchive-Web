require 'rails_helper'

describe Song do

  it "is valid with an artist, album and name" do
    song = build_song_with_artist_and_album
    expect(song.save).to be true
  end

  it "is invalid without an artist" do
    artist = FactoryBot.create(:artist)
    album = FactoryBot.build(:album)
    album.artists << artist
    song = FactoryBot.build(:song)
    song.album = album
    # Song AND Album need artists i.e. "features etc.."
    expect(album.save).to be true
    expect(song.save).to be false
  end

  it "is invalid without an album" do
    artist = FactoryBot.create(:artist)
    song = FactoryBot.build(:song)
    song.artists << artist
    expect(song.save).to be false
  end

  it "is invalid without a name" do
    song = build_song_with_artist_and_album
    song.name = nil
    expect(song.save).to be false
  end

  it "is invalid without a unique name" do
    song = build_song_with_artist_and_album
    name = song.name
    song2 = build_song_with_artist_and_album({name: name})
    expect(song.save).to be true
    expect(song2.save).to be false
  end

  def build_song_with_artist_and_album(opts = {})
    artist = FactoryBot.create(:artist)
    album = FactoryBot.build(:album)
    if opts[:name]
      song = FactoryBot.build(:song, name: opts[:name])
    else
      song = FactoryBot.build(:song)
    end
    album.artists << artist
    song.album = album
    song.artists << artist
    album.save

    return song
  end

end
