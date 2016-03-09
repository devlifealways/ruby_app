$(document).ready(function () {
  // it will fade out the welcome message : phoenix says hello by the way !
  window.setTimeout(function() {
    $("#remove-me").fadeTo(1000, 0).slideUp(1000, function(){
      $(this).remove();
    });
  }, 5000);

});
