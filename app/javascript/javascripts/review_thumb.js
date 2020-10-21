$(document).on('turbolinks:load', function () {
  $(".subImage li").on("click", function(){
    var class_name = $(this).attr("class");
    var num = class_name.slice(11);
    $(".mainImage li").hide();
    $(".mainImg-list" + num).fadeIn();
  });
});
