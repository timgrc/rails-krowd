$(function() {
  geoChartMap();
  donut();
  // centerDonutInner();
  first_donut();
  second_donut();
  third_donut();

  ftest();
  console.log('console');
});

$( window ).resize(function() {
  geoChartMap();
  donut();
  // centerDonutInner();
  first_donut();
  second_donut();
  third_donut();
  ftest();
  console.log('blabla');
});

function ftest() {
  var donutGeneralWidth, donutGeneralHeight, gridDonutWidth, gridDonutHeight, widthHeightDonut,donutInnovationWidth, donutInnovationHeight, percentageGrid;
  percentageGrid = 0.80;
  gridDonutWidth  = $('.grid-donut').width();
  gridDonutHeight = $('.grid-donut').height();
  donutGeneralWidth  = $('.donut-chart-general').width();
  donutGeneralHeight = $('.donut-chart-general').height();
  donutInnovationWidth  = $('.donut-chart-innovation').width();
  donutInnovationHeight = $('.donut-chart-innovation').height();

  widthHeightDonut = percentageGrid * Math.min(gridDonutWidth, gridDonutHeight);
  $('.donut-chart-general').width(widthHeightDonut);
  $('.donut-chart-general').height(widthHeightDonut);
  $('.donut-chart-innovation').width(widthHeightDonut);
  $('.donut-chart-innovation').height(widthHeightDonut);
}
