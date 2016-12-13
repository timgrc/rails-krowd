function centerDonutInner() {
  var donutInner,
    donutTop,
    donutHeight,
    donutInnerTop,
    donutInnerHeight,
    FromDonutTopToDonutInnerTop,
    marginTopdonutInner;

  donutInner       = $('.donut-chart-general').parent().find('.donut-inner')

  donutTop         = $('.donut-chart-general').position().top;
  donutHeight      = $('.donut-chart-general').height();

  donutInnerTop    = donutInner.position().top;
  donutInnerHeight = donutInner.height();

  FromDonutTopToDonutInnerTop = donutHeight / 2 - donutInnerHeight / 2;
  marginTopdonutInner = -(donutInnerTop - (donutTop + FromDonutTopToDonutInnerTop));

  donutInner.css({marginTop: marginTopdonutInner});
}
