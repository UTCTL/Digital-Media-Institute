// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var challengeForm = function(){
  return {
    contentAddImage: function(imageURL) {
      var textArea = $("#challenge_content")[0];
      var imgTag = "<img src=\""+imageURL+"\"/>";
      util.insertAtCaret(textArea,imgTag);
    },
    chooseAssets: function(assetsURL) {
      $("#challenge_assets").val(assetsURL);
      $("#assets_display").text(assetsURL);
    }
  }
}();
