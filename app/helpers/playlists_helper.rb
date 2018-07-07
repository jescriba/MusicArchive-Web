module PlaylistsHelper
  def songs_from_params(params = {})
    song_ids = params[:playlist][:song_ids] || params[:song_ids]
    song_names = params[:playlist][:song_names] || params[:song_names]
    return [] unless song_ids || song_names

    songs = []
    if song_names
      song_names.split(",").each do |song_name|
        s = Song.find_by name: song_name
        songs.push(s) if s
      end
    end

    if song_ids
      song_ids.split(",").each do |song_id|
        s = Song.find_by id: song_id
        songs.push(s) if s
      end
    end

    return songs
  end
end
