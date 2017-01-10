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
      $('#page-description').html('<i class="fa fa-tachometer" aria-hidden="true"></i><span>Weekly activity</span>');
    } else if (windowTop <= (generalHeight + mapHeight / 2)) {
      $(".tab").removeClass("active");
      $(".tab-badges").addClass("active");
      $('#page-description').html('<i class="fa fa-globe" aria-hidden="true"></i><span>Reward active members</span>');
    } else if (windowTop <= (generalHeight + mapHeight + organizationHeight / 2)) {
      $(".tab").removeClass("active");
      $(".tab-organization").addClass("active");
      $('#page-description').html('<i class="fa fa-users" aria-hidden="true"></i><span>Analyse organization impact</span>');
    } else if (windowTop <= (generalHeight + mapHeight + organizationHeight + innovationHeight / 2)) {
      $(".tab").removeClass("active");
      $(".tab-innovation").addClass("active");
      $('#page-description').html('<i class="fa fa-lightbulb-o" aria-hidden="true"></i><span>Assess innovation capacity</span>');
    } else {
      $(".tab").removeClass("active");
      $(".tab-push").addClass("active");
      $('#page-description').html('<i class="fa fa-check" aria-hidden="true"></i><span>Engage your collaborators</span>');
    }
  }
}
