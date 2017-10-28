require 'rails_helper'

describe Album do

  it "is valid with an artist and name" do
    artist = FactoryBot.create(:artist)
    album = FactoryBot.build(:album, name: "test")
    album.artists << artist
    expect(album.save).to be true
  end

  it "is invalid without an artist" do
    expect(FactoryBot.build(:album, name: "test").save).to be false
  end

  it "is invalid without a name" do
    artist = FactoryBot.create(:artist)
    album = FactoryBot.build(:album, name: nil)
    album.artists << artist
    expect(album.save).to be false
  end

  it "is invalid without a unique name" do
    artist = FactoryBot.create(:artist)
    album = FactoryBot.build(:album, name: "test")
    album2 = FactoryBot.build(:album, name: "test")
    album.artists << artist
    album2.artists << artist
    expect(album.save).to be true
    expect(album2.save).to be false
  end

end
