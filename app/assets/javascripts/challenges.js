// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var challengeForm = function(){
  var that =  {
    contentAddImage: function(imageURL) {
      var textArea = $("#challenge_content")[0];
      var imgTag = "<img src=\""+imageURL+"\"/>";
      util.insertAtCaret(textArea,imgTag);
    },
    chooseAssets: function(assetsURL) {
      $("#challenge_assets").val(assetsURL);
      $("#assets_display").text(assetsURL);
      $(".clearAssetsLink").css("display","inline");
    },
    clearAssets: function(){
      $(".clearAssetsLink").css("display","none");
      $("#challenge_assets").val('');
      $("#assets_display").text('');

    }
  }

  $("#challenge_category_parent_id").change(function(){
    $("#challenge_category_title").toggle( $(this).val() == '' ).val('');
  });

  $(".clearAssetsLink").css("display",( $("#challenge_assets").val() != '' ) ? "inline":"none");

  $("#challenge_category_parent_id").trigger("change");
  return that;
};
