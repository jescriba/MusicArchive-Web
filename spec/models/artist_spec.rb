require 'rails_helper'

describe Artist do

  it "has a valid factory" do
    expect(FactoryBot.build(:artist).save).to be true
  end

  it "is invalid without a name" do
    expect(FactoryBot.build(:artist, name: nil).save).to be false
  end

  it "is invalid without a unique name" do
    artist = FactoryBot.create(:artist)
    expect(FactoryBot.build(:artist, name: artist.name).save).to be false
  end

  it "has songs" do
    artist = FactoryBot.create(:artist)
    expect(artist.songs.length).to satisfy { |count| count > 0 }
  end

  it "has albums" do
    artist = FactoryBot.create(:artist)
    expect(artist.albums.length).to satisfy { |count| count > 0 }
  end

end
