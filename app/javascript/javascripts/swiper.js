$(document).on("turbolinks:load", function () {
  new Swiper(".swiper-container", {
    spaceBetween: 0,
    effect: "fade",
    autoplay: {
      delay: 5000,
      stopnOnLastSlide: false,
      reverseDirection: false
    },
    speed: 3000,
  });
});
