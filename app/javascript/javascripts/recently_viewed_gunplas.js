$(document).on("turbolinks:load", function (){
  var gunpla = String( gon.gunpla_id );
  var cookie_name = 'recently_viewed_gunplas';
  var viewed_gunplas = [];
  var delete_gunpla = false;
  $.cookie.defaults.path = "/";

  // 既にクッキーが存在している場合は、ストリングを配列にする
  if($.cookie(cookie_name)){
    viewed_gunplas = $.cookie(cookie_name).split(",");
  }
  // 重複していれば削除
  var idx = viewed_gunplas.indexOf(gunpla);
  if ($.inArray(gunpla, viewed_gunplas) >= 0) {
    viewed_gunplas.splice(idx, 1);
  }
  // 重複していなければ、gunplaを配列に追加
  if($.inArray(gunpla, viewed_gunplas)<0){
    viewed_gunplas.push(gunpla);
  }

  // 5個以上ならば1つ削除
  if (viewed_gunplas.length >= 5){
    viewed_gunplas.shift();
  }

  // 配列をクッキ―に保存
  $.cookie(cookie_name, viewed_gunplas);

});
