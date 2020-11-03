$(document).on("turbolinks:load", function () {
  $("#subImage li").on("click", function(){
    var id_name = $(this).attr("id");
    var num = id_name.slice(11);
    $("#mainImage li").hide();
    $("#mainImg-list" + num).fadeIn();
  });
});
