//Defines behavior of the New and Edit lesson forms
var lessonForm = function(){
  var _fields = {};
  var _selectedKind = "";
  var _form_id = "";
  
  var _addFormField = function(field){
    $(_form_id+" .actions").before(field);
  };
  
  var getVimeoInfo_result = function(data){
    var video = data[0];
    
    $("#lesson_title").val(video.title);
    $("#lesson_content").val(video.description);
    $("#lesson_thumbnail").val(video.thumbnail_medium);
    $("#thumbnailField").append("<img src=\""+video.thumbnail_medium+"\"/>");
  };
  
  var xhrError = function(xhr, status, error){
    alert("error");
  };
  
  return {
      init :function(form_id){
        _form_id = form_id;
        
        //Event Handlers
        var owner = this;
       /* $("#lesson_kind").change(function(){
          owner.setSelectedKind( $(this).val() );
        });*/
        
        $("#lesson_link").on("paste", function(event){
          setTimeout(function(){ owner.processLink() },0);
        });
        
        
        //detach and store dynamic form fields
       /* $(_form_id+" .dynamic").detach().each(function(index){
          var id = $(this).attr("id");
          _fields[id] = this;
        });
        
        
        this.setSelectedKind( $("#lesson_kind").val() );*/
      },
      processLink: function(){
        var link = $("#lesson_link").val();
        
        var vimeoRegexp = /^.*vimeo\.com\/([0-9]+)/;
                
        var matches = link.match(vimeoRegexp);
        
        if(matches)
          this.getVimeoInfo(matches[1]);
      },
      getVimeoInfo: function(video_id){
        $.ajax({url:"http://vimeo.com/api/v2/video/"+video_id+".json",dataType:"jsonp", success: getVimeoInfo_result, error: xhrError });
      },
      getSelectedKind: function(){
        return _selectedKind;
      },
      setSelectedKind: function(value){
        

        if(_selectedKind !== value)
        {
          _selectedKind = value;
          
          $(_form_id+" .dynamic").remove();
          
          if(_selectedKind === "Video" || _selectedKind === "Link")
          {
            _addFormField(_fields["linkField"]);
            _addFormField(_fields["thumbnailField"]);
            _addFormField(_fields["titleField"]);
            _addFormField(_fields["contentField"]);
          }
          else
          {
            _addFormField(_fields["titleField"]);
            _addFormField(_fields["contentField"]);
          }
          
          
        }
        
      }
  };
}();
