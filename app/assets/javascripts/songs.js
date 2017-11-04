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
  var currentSong;
  var songs = gon.songs;
  var currentSongIndex = 0;
  var page = 1;

  function nextSong() {
    return songs[++currentSongIndex % songs.length];
  }
  function lastSong() {
    return songs[--currentSongIndex % songs.length];
  }
  $(window).scroll(function() {
     if ($(window).scrollTop() + window.innerHeight > $(document).height() - 60 && !isLoading) {
       isLoading = true;
       page += 1;
       $.ajax({
         headers: {
           Accept: "application/javascript"
         },
         type: "GET",
         url: "songs?page=" + page
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
  $("audio").on("ended", function() {
    updateSongDetails(nextSong());
  });
  $("audio").on("play", function() {
    updatePlayingState();
  });
  $("audio").on("pause", function() {
    updatePlayingState();
  });

  function isPlaying() {
    return !$("audio").get(0).paused;
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
    $("audio").get(0).play();
  }

  function stopPlaying() {
    $("audio").get(0).pause();
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
    $("audio").attr("src", song.url);
    $("#song-name").text(song.name);
    $("#download").show();
  }
};

$(document).ready(ready);
$(document).on('page:change', ready);
