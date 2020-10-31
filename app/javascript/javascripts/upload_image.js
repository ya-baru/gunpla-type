$(document).on("turbolinks:load", function () {
  $("#article_image").on("change", function () {
    var size_in_megabytes = this.files[0].size / 1024 / 1024;
    if (size_in_megabytes > 3) {
      alert(
        "最大ファイルサイズは３MB未満です。\nこれより小さいファイルを選択してください。"
      );
      $("#article_image").val("");
    }
  });
});
