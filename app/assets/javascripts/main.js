$(function() {
  scrolling();
  onLoadAndResize();
});

$(window).resize(function() {
  onLoadAndResize();
});

$(window).scroll(function() {
  scrolling();
});

function onLoadAndResize() {
  retentionChart();
  departmentChart();
  geoChartMap();
  commentsCountryChart();
  businessCountriesDepartmentsChart();
  technologyCountriesDepartmentsChart();
  first_donut();
  second_donut();
  third_donut();
}
