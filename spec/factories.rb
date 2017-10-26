FactoryBot.define do

  factory :album do
    sequence(:name) { |n| "Album #{n}" }
    description "Lorem ipsum"
    release_date Date.new

    transient do
      artists_count 2
      songs_count 10
    end

    after(:create) do |album, evaluator|
      create_list(:artist, evaluator.artists_count, albums: [album])
      create_list(:song, evaluator.songs_count, artists: album.artists, album: album)
    end
  end

  factory :song do
    sequence(:name) { |n| "Song #{n}" }
    description "Lorem ipsum"
    recorded_date Date.new

    album
  end

  factory :artist do
    sequence(:name) { |n| "Artist #{n}" }
    description "Lorem ipsum"

    transient do
      albums_count 2
      songs_count 10
    end

    after(:create) do |artist, evaluator|
      create_list(:album, evaluator.albums_count, artists: [artist])
      create_list(:song, evaluator.songs_count, artists: [artist], album: artist.albums.first)
    end
  end

end
