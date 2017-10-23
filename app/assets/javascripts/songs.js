
$( window ).on('load', function() {
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
});
