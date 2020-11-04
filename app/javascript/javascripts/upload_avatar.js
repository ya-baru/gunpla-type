$(document).on("turbolinks:load", function () {
  $("#user_avatar").on("change", function () {
    var size_in_megabytes = this.files[0].size / 1024 / 1024;
    var ImgSrc = "https://placehold.jp/150x150.png?text=Non-Image";
    if (size_in_megabytes > 3) {
      alert(
        "最大ファイルサイズは３MB未満です。\nこれより小さいファイルを選択してください。"
      );
      $("#user_avatar").val("");
      $(".prev-image").attr({ src: ImgSrc });
    }
  });

  $(function () {
    function buildHTML(image) {
      var html =
        `
          <div class="prev-content">
            <img src="${image}", alt="preview" class="prev-image shadow-sm" width=150 height=150>
          </div>
        `;
      return html;
    }

    $(document).on("change", ".hidden_file", function () {
      var file = this.files[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function () {
        var image = this.result;
        if ($(".prev-content").length == 0) {
          var html = buildHTML(image);
          $(".prev-contents").prepend(html);
          $(".photo-icon").hide();
        } else {
          $(".prev-content .prev-image").attr({ src: image });
        }
      };
    });
  });
});
