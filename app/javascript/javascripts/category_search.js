$(document).on("turbolinks:load", function () {
  function appendChildrenList(child) {
    var html =
      `
        <li class="child-${child.id} dropright drop-hover">
          <a id="${child.id}" class="child_category dropdown-item dropdown-toggle" href="/gunplas/${child.id}/select_category_index">
            ${child.name}
          </a>
        </li>
      `;
    return html;
  }

  function appendChildrenBox(insertHTML) {
    var childSelectHtml =
      `
        <ul class="child_category_box dropdown-menu">
          <h6 class="border-bottom text-center">グレード</h6>
          ${insertHTML}
        </ul>
      `;
    return childSelectHtml;
  }

  function appendGrandChildList(grandchild) {
    var html =
      `
        <li class="child-${grandchild.id} dropright drop-hover">
          <a id="${grandchild.id}" class="grandchild_category dropdown-item" href="/gunplas/${grandchild.id}/select_category_index">
            ${grandchild.name}
          </a>
        </li>
      `;
    return html;
  }

  function appendGrandChildrenBox(insertHTML) {
    var grandchildSelectHtml =
      `
        <ul class="grandchild_category_box dropdown-menu">
          <h6 class="border-bottom text-center">スケール</h6>
          ${insertHTML}
        </ul>
      `;
    return grandchildSelectHtml;
    $(".grandchildren_list").append(grandchildSelectHtml);
  }

  $(".category_box").on("click", function(){
    $(".child_category_box").remove();
    $(".grandchild_category_box").remove();
  });

  $(".parent_category").on("mouseover", function() {
    var parentId = this.id;
    $.ajax({
      type: "GET",
      url: "/gunplas/get_category_children",
      data: { parent_id: parentId },
      dataType: "json",
    }).done(function(children) {
      $(".child_category_box").remove();
      $(".grandchild_category_box").remove();
      var insertHTML = "";
      children.forEach(function(child) {
        insertHTML += appendChildrenList(child);
      });
      var html = appendChildrenBox(insertHTML);
      $(".parent-"+`${parentId}`).append(html);
    })
  });

  $(document).on("mouseover", ".child_category", function() {
    var childId = this.id;
    $.ajax({
      type: "GET",
      url: "/gunplas/get_category_grandchildren",
      data: { child_id: childId },
      dataType: "json",
    }).done(function(grandchildren) {
      $(".grandchild_category_box").remove();
      var insertHTML = "";
      grandchildren.forEach(function(grandchild) {
        insertHTML += appendGrandChildList(grandchild);
      });
      var html = appendGrandChildrenBox(insertHTML);
      $(".child-"+`${childId}`).append(html);
    })
  });
});
