$(document).ready(function(){

  $(".tab").on("click", function(e){
    // Change active tab
    $(".tab").removeClass("active");
    $(this).addClass("active");
  });

});

$(document).ready(function(){
  $('a.tab').bind('click', function(event) {
    var anchor = $(this).attr('href');

    $('html, body').stop().animate({
        scrollTop: $(anchor).offset().top
    }, 1500, 'easeInOutExpo');
    event.preventDefault();
  });
});

// //jQuery to collapse the navbar on scroll
// $(window).scroll(function() {
//     if ($(".navbar-wagon").offset().top > 100) {
//         $(".navbar-wagon").addClass("top-nav-collapse");
//     } else {
//         $(".navbar-wagon").removeClass("top-nav-collapse");
//     }
// });
