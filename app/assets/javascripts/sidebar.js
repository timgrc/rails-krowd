$(document).ready(function(){

  $(".tab").on("click", function(e){
    // Change active tab
    $(".tab").removeClass("active");
    $(this).addClass("active");

    // Hide all tab content
    $(".tab-content").addClass("hidden");

    // Show target tab
    tabSelector = $(this).data("target");
    $(tabSelector).removeClass("hidden");
  });

});

$(document).ready(function(){

  $("#menu-toggle").on("click", function(e){
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");

    $(this).toggleClass("clicked")
  });

});