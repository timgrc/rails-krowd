$(function() {
  if ($("#regions_div").length) {
    geoChartMap();
    donut();
    first_donut();
    second_donut();
    third_donut();
  }
});

$( window ).resize(function() {
  if ($("#regions_div").length) {
    geoChartMap();
    donut();
    first_donut();
    second_donut();
    third_donut();

    $('#comments').html($(window).width());
  }
});
