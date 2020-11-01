$(document).on("turbolinks:load", function () {
  var pagetop = $('#page_top');
  pagetop.hide();
  $(window).on("scroll", function () {
    if ($(this).scrollTop() > 100) {
      pagetop.fadeIn();
    } else {
      pagetop.fadeOut();
    }
  });
  pagetop.on("click", function () {
    $('body, html').animate({ scrollTop: 0 }, 500);
    return false;
  });
});
