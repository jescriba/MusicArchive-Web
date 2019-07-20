FactoryBot.define do
  factory :playlist do
    name { "MyString" }
    description { "MyText" }
  end
  factory :playlist_song do
    
  end

  factory :album do
    sequence(:name) { |n| "Album #{n}" }
    description { "Lorem ipsum" }
    release_date { Date.new }
  end

  factory :song do
    sequence(:name) { |n| "Song #{n}" }
    description { "Lorem ipsum" }
    recorded_date { Date.new }
  end

  factory :artist do
    sequence(:name) { |n| "Artist #{n}" }
    description { "Lorem ipsum" }

    transient do
      albums_count { 2 }
      songs_count { 10 }
    end

    after(:create) do |artist, evaluator|
      create_list(:album, evaluator.albums_count, artists: [artist])
      create_list(:song, evaluator.songs_count, artists: [artist], album: artist.albums.first)
    end
  end

end
