$(function(){

  $(".tab").on("click", function(e){
    e.preventDefault();
    // Change active tab
    $(".tab").removeClass("active");
    $(this).addClass("active");

    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: target.offset().top - 40
        }, 1000);
      }
    }
  });

});


