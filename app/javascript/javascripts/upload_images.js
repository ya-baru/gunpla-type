$(document).on('turbolinks:load', function () {
  var count = $(".image-box").length;
  if(count == 3) {
    $(".input_btn").hide();
  }

  $("#review_images").on('change',function(e){
    var files = e.target.files;
    var d = (new $.Deferred()).resolve();
    var size_in_megabytes = this.files[0].size / 1024 / 1024;

    if (size_in_megabytes > 3) {
      alert(
        "画像は1つのファイル3MB以内にしてください"
      );
      $("#review_images").val("");
      return
    }
    $.each(files,function(i,file){
      d = d.then(function() {
        return Uploader.upload(file)})
      .then(function (data) {
        return previewImage(file, data.image_id);
      });
    });
    $("#review_images").val("");
  });

  $(".images_field").on("click", ".btn-edit", function(e) {
    e.preventDefault();
    $(this).parent().find(".edit-image-file-input").trigger("click");
  });

  $(".images_field").on("change", ".edit-image-file-input", function(e) {
    var file = e.target.files[0];
    var image_box = $(this).parent();
    var size_in_megabytes = this.files[0].size / 1024 / 1024;

    if (size_in_megabytes > 3) {
      alert(
        "画像は1つのファイル3MB以内にしてください"
      );
      $(".edit-image-file-input").val("");
      return
    }
    Uploader.upload(file).done(function(data) {
      replaceImage(file, data.image_id, image_box);
    });
  });

  $(".images_field").on("click",".btn-delete", function(e){
    e.preventDefault();
    $(this).parent().remove();

    var count = $(".image-box").length;
    if(count < 3) {
      $(".input_btn").show();
    }
  });

  var replaceImage = function(imageFile, image_id, element) {
    var reader = new FileReader();
    var img = element.find("img");
    var input = element.find(".review-images-input");
    var filename = element.find("p");
    reader.onload = function(e) {
      input.attr({value: image_id});
      filename.html(imageFile.name);
      img.attr("src", e.target.result);
    };
    reader.readAsDataURL(imageFile);
  }

  var previewImage = function(imageFile, image_id){
    var reader = new FileReader();
    var img = new Image();
    var def =$.Deferred();
    reader.onload = function(e){
      var image_box = $('<div>', { class: "image-box col-4" });
      var shadow = $('<div>', { class: "shadow-sm" });
      shadow.append(img);
      image_box.append(shadow);
      image_box.append($('<p>').html(imageFile.name).attr({
        class: "mb-1"
      }));
      image_box.append($('<input>').attr({
        name: "review[images][]",
        value: image_id,
        style: "display: none;",
        type: "hidden",
        class: "review-images-input"
      }));
      image_box.append('<a href="" class="btn-edit mr-2"><i class="far fa-file-image"></i></a>');
      image_box.append($('<input>').attr({
        name: "edit-image[]",
        style: "display: none;",
        type: "file",
        accept: "image/jpeg,image/png",
        class: "edit-image-file-input file-input"
      }));
      image_box.append('<a href="" class="btn-delete"><i class="far fa-trash-alt"></i></a>');
      $(".images_field .row").append(image_box);
      img.src = e.target.result;

      var count = $(".image-box").length;
      if(count == 3) {
        $(".input_btn").hide();
      }
      def.resolve();
    };
    reader.readAsDataURL(imageFile);
    return def.promise();
  }

  var Uploader = {
    upload: function(imageFile){
      var def =$.Deferred();
      var formData = new FormData();
      formData.append("image", imageFile);
      $.ajax({
        type: "POST",
        url: "/reviews/upload_image",
        data: formData,
        dataType: "json",
        processData: false,
        contentType: false,
        success: def.resolve
      })
      return def.promise();
    }
  }
});
