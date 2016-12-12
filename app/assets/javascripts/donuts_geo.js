$(function() {
  geoChartMap();
  donut();
  centerDonutInner();
});

$( window ).resize(function() {
  geoChartMap();
  donut();
  centerDonutInner();
});
