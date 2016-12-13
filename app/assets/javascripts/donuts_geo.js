$(function() {
  geoChartMap();
  donut();
  centerDonutInner();
  first_donut();
  second_donut();
  third_donut();

  ftest();
});

$( window ).resize(function() {
  geoChartMap();
  donut();
  centerDonutInner();
  first_donut();
  second_donut();
  third_donut();

  ftest();
});

function ftest() {
  var donutGeneralWidth, donutGeneralHeight, gridDonutWidth, gridDonutHeight, widthHeightDonut, percentageGrid;
  percentageGrid = 0.90;
  gridDonutWidth  = $('.grid-donut').width();
  gridDonutHeight = $('.grid-donut').height();
  donutGeneralWidth  = $('.donut-chart-general').width();
  donutGeneralHeight = $('.donut-chart-general').height();

  widthHeightDonut = percentageGrid * Math.min(gridDonutWidth, gridDonutHeight);
  $('.donut-chart-general').width(widthHeightDonut);
  $('.donut-chart-general').height(widthHeightDonut);
}
