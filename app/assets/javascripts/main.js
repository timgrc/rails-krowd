$(function() {
  scrolling();
  geoChartMap();
});

$(window).resize(function() {
  geoChartMap();
});

$(window).scroll(function() {
  scrolling();
});
