function centerDonutInner() {
  var donutInner,
    donutTop,
    donutHeight,
    donutInnerTop,
    donutInnerHeight,
    FromDonutTopToDonutInnerTop,
    marginTopdonutInner,
    gridDonutHeight;

    gridDonutHeight = $('.grid-donut').height();
    DonutDiameter   = 0.8 * gridDonutHeight;

  $('.donut-chart').each(function() {
    $(this).css({height: DonutDiameter, width: DonutDiameter});

    donutInner       = $(this).parent().find('.donut-inner')

    donutTop         = $(this).position().top;
    donutHeight      = $(this).height();

    donutInnerTop    = donutInner.position().top;
    donutInnerHeight = donutInner.height();

    FromDonutTopToDonutInnerTop = donutHeight / 2 - donutInnerHeight / 2;
    marginTopdonutInner = -(donutInnerTop - (donutTop + FromDonutTopToDonutInnerTop));

    donutInner.css({marginTop: marginTopdonutInner});
  });

}
