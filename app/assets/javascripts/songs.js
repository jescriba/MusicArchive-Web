var songsPage = 2;
var currentSongIndex = 0;
var currentSong;
var audio = new Audio('');
var ready = function() {
  $("#lossless-download").click(function(event) {
    event.preventDefault();
    url = $(this).attr('song-url');
    window.location.href = url;
  });
  $("#lossy-download").click(function(event) {
    event.preventDefault();
    url = $(this).attr('song-url');
    window.location.href = url;
  });

  var isLoading = false;
  var songs = [];
  if (gon.songs != undefined) {
    songs = gon.songs;
  }
  if (currentSong) {
    updatePlayingState();
  }

  function nextSong() {
    return songs[++currentSongIndex % songs.length];
  }
  function lastSong() {
    return songs[--currentSongIndex % songs.length];
  }
  $(window).scroll(function() {
     if ($(window).scrollTop() + window.innerHeight > $(document).height() - 60 && !isLoading) {
       isLoading = true;
       $.ajax({
         headers: {
           Accept: "application/javascript"
         },
         type: "GET",
         url: "songs?page=" + songsPage
       }).done(function(data) {
         isLoading = false;
         // Prevent songsPage from incrementing when
         // no songs were added
         if (data != "" && $("#song-list").length != 0) {
           songsPage += 1;
         }
       });
     }
  });
  $(document).on("click", ".song-link", function(event) {
    var song = "";
    var id = parseInt(event.currentTarget.id);
    for(var i = 0; i < songs.length; i++) {
      if(songs[i].id == id) {
        song = songs[i]
        currentSongIndex = i;
        break;
      }
    }
    updateSongDetails(song);
    updatePlayingState();
  });
  $(document).on("click", "#play", function(event) {
    startPlaying();
  });
  $(document).on("click", "#pause", function(event) {
    stopPlaying();
  });
  $(document).on("click", "#forward", function(event) {
    updateSongDetails(nextSong());
  });
  $(document).on("click", "#backward",  function(event) {
    updateSongDetails(lastSong());
  });
  $(document).on("click", ".download", function(event) {
    event.preventDefault();
    window.location.href = currentSong.url;
  });
  $(document).on("click", ".share", function(event) {
    window.prompt("Copy direct link to song: Command+C, Enter", BASE_URL + "/songs/" + currentSong.id);
    event.stopPropagation();
  });
  audio.onended = function() {
    updateSongDetails(nextSong());
  };
  audio.onplay = function() {
    updatePlayingState();
  };
  audio.onpause = function() {
    updatePlayingState();
  };

  function isPlaying() {
    return !audio.paused;
  }

  function updatePlayingState() {
    if (isPlaying()) {
      $("#play").hide();
      $("#pause").show();
    } else {
      $("#play").show();
      $("#pause").hide();
    }
  }

  function startPlaying() {
    audio.setAttribute("src", currentSong.url);
    audio.play();
  }

  function stopPlaying() {
    audio.pause();
  }

  function updateSongDetails(song) {
    currentSong = song;
    $("#forward").show();
    $("#backward").show();
    $("p#" + song.id + ".song-details").show();
    $(".song-details").hide();
    $("div#" + song.id + ".song-details").show();
    $(".song-link").removeClass("active");
    $(".song-link#" + song.id).addClass("active");
    audio.setAttribute("src", song.url);
    $("#song-name").text(song.name);
    $("#download").show();
  }
};

document.addEventListener("turbolinks:load", ready);
