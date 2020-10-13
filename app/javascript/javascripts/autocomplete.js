$(document).on("turbolinks:load", function () {
  const dataList = function(request, response) {
    $.ajax({
      type: "GET",
      url: "/gunplas/autocomplete/",
      dataType: "json",
      cache: true,
      data: { name: request.term },
      success: function(data) {
        response(data);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        response([""]);
      }
    });
  }
  $("#q_name_cont").autocomplete({
    source: dataList,
    autoFocus: true,
    delay: 300,
    minLength: 2
  })
})
