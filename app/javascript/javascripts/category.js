$(document).on("turbolinks:load", function () {
  function appendOption(category) {
    var html = `<option value="${category.id}">${category.name}</option>`;
    return html;
  }

  function appendChildrenBox(insertHTML) {
    var childSelectHtml = "";
    childSelectHtml = `
                          <option value="">
                            選択して下さい
                          </option>
                          ${insertHTML}
                        `;
    $("#gunpla_child_category").append(childSelectHtml);
  }

  function appendGrandchildrenBox(insertHTML) {
    var grandchildSelectHtml = "";
    grandchildSelectHtml = `${insertHTML}`;
    $("#gunpla_grandchild_category").append(grandchildSelectHtml);
  }

  $("#gunpla_parent_category").on("change", function () {
    var parentId = document.getElementById("gunpla_parent_category").value;
    if (parentId != "") {
      $.ajax({
        url: "/gunplas/get_category_children/",
        type: "GET",
        data: { parent_id: parentId },
        dataType: "json",
      })
        .done(function (children) {
          $("#gunpla_child_category option").remove();
          $("#gunpla_grandchild_category option").remove();
          var insertHTML = "";
          children.forEach(function (child) {
            insertHTML += appendOption(child);
          });
          appendChildrenBox(insertHTML);
        })
        .fail(function () {
          alert("データ取得に失敗しました");
        });
    } else {
      $("#gunpla_child_category option").remove();
      $("#gunpla_grandchild_category option").remove();
    }
  });

  $("#category_child").on("change", "#gunpla_child_category", function () {
    var childId = document.getElementById("gunpla_child_category").value;

    if (childId != "") {
      $.ajax({
        url: "/gunplas/get_category_grandchildren",
        type: "GET",
        data: { child_id: childId },
        dataType: "json",
      })
        .done(function (grandchildren) {
          $("#gunpla_grandchild_category option").remove();
          var insertHTML = "";
          grandchildren.forEach(function (grandchild) {
            insertHTML += appendOption(grandchild);
          });
          appendGrandchildrenBox(insertHTML);
        })
        .fail(function () {
          alert("データ取得に失敗しました");
        });
    } else {
      $("#gunpla_grandchild_category option").remove();
    }
  });
});
