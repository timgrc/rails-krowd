function scrolling() {
  var windowTop,
    generalHeight,
    mapHeight,
    organizationHeight,
    innovationHeight,
    pushHeight;

  windowTop    = $(window).scrollTop();
  windowHeight = $(window).height();
  windowDown   = windowTop + windowHeight;

  generalHeight = $('#general').height();
  mapHeight = $('#badges').height();
  organizationHeight = $('#organization').height();
  innovationHeight = $('#innovation').height();
  pushHeight = $('#push').height();

  if ($(".tab-general").length !== 0) {
    if (windowTop <= (generalHeight / 2)){
      $(".tab").removeClass("active");
      $(".tab-general").addClass("active");
    } else if (windowTop <= (generalHeight + mapHeight / 2)) {
      $(".tab").removeClass("active");
      $(".tab-badges").addClass("active");
    } else if (windowTop <= (generalHeight + mapHeight + organizationHeight / 2)) {
      $(".tab").removeClass("active");
      $(".tab-organization").addClass("active");
    } else if (windowTop <= (generalHeight + mapHeight + organizationHeight + innovationHeight / 2)) {
      $(".tab").removeClass("active");
      $(".tab-innovation").addClass("active");
    } else {
      $(".tab").removeClass("active");
      $(".tab-push").addClass("active");
    }
  }
}
