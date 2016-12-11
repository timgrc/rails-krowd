$(function() {
  centerDonutInner();
});

$(window).resize(function() {
  centerDonutInner();
});

function centerDonutInner() {
  var donutInner,
    donutTop,
    donutHeight,
    donutInnerTop,
    donutInnerHeight,
    FromDonutTopToDonutInnerTop,
    marginTopdonutInner;
  $('.donut-chart').each(function() {
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
