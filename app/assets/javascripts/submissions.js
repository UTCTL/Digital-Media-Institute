// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var submissionsForm = function(spec){
  var that = {};
  
  var _formObj = $(spec.form_id);
  var _loadingObj = $(spec.loading_id).detach();

  that.uploadStart = function(){
    _loadingObj.insertBefore(_formObj);
    _formObj.detach();

  };

  that.uploadError = function(){
    _formObj.insertBefore(_loadingObj);
    _loadingObj.detach();
  };

  that.uploadComplete = function(){
    alert("upload Complete");
  };
  
  _formObj.submit(function(){
  
    that.uploadStart();
  });

  return that;
};
