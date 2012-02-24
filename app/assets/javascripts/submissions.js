// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var imageUploadForm = function(spec){
  var that = {};
  
  var _formObj = $(spec.form_id);
  var _loadingObj = $(spec.loading_id).css("display","none");

  that.uploadStart = function(){
    _loadingObj.css("display","block");
    _formObj.css("display","none");

  };

  that.uploadError = function(html){
    _formObj.css("display","block");
    _loadingObj.css("display","none");
    $("#errors").html( html);
  };

  that.uploadComplete = function(html){
    var answerObj = $(html);
    $("#answerContent").replaceWith(answerObj);

    _loadingObj.css("display","none");
  };
  
  _formObj.submit(function(){
  
    that.uploadStart();
  });

  return that;
};
