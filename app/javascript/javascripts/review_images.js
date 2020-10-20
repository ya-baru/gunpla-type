$(document).on('turbolinks:load', function() {
  $("#review_images").on('change',function(e){
    var files = e.target.files;
    var d = (new $.Deferred()).resolve();
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
    Uploader.upload(file).done(function(data) {
      replaceImage(file, data.image_id, image_box);
    });
  });

  $(".images_field").on("click",".btn-delete", function(e){
    e.preventDefault();
    $(this).parent().remove();
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
      image_box.append(img);
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
      image_box.append('<a href="" class="btn-edit btn btn-success btn-sm mr-2">編集</a>');
      image_box.append($('<input>').attr({
        name: "edit-image[]",
        style: "display: none;",
        type: "file",
        class: "edit-image-file-input file-input"
      }));
      image_box.append('<a href="" class="btn-delete btn btn-danger btn-sm">削除</a>');
      $('.images_field .row').append(image_box);
      img.src = e.target.result;
      def.resolve();
    };
    reader.readAsDataURL(imageFile);
    return def.promise();
  }

  var Uploader = {
    upload: function(imageFile){
      var def =$.Deferred();
      var formData = new FormData();
      formData.append('image', imageFile);
      $.ajax({
        type: "POST",
        url: "/reviews/upload_image",
        data: formData,
        dataType: 'json',
        processData: false,
        contentType: false,
        success: def.resolve
      })
      return def.promise();
    }
  }
});
