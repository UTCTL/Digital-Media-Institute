//Defines behavior of the New and Edit lesson forms
var lessonForm = function(){
  var _fields = {};
  var _selectedKind = "";
  var _form_id = "";
  
  var _addFormField = function(field){
    $(_form_id+" .actions").before(field);
  };
  
  return {
      init :function(form_id){
        _form_id = form_id;
        
        //detach and store dynamic form fields
        $(_form_id+" .dynamic").detach().each(function(index){
          var id = $(this).attr("id");
          _fields[id] = this;
        });
        
        //Event Handlers
        var owner = this;
        $("#lesson_kind").change(function(){
          owner.setSelectedKind( $(this).val() );
        });
        
        this.setSelectedKind( $("#lesson_kind").val() );
      },
      getSelectedKind: function(){
        return _selectedKind;
      },
      setSelectedKind: function(value){
        
<<<<<<< HEAD
        if(_selectedKind !== value)
=======
        if(_selectedKind != value)
>>>>>>> f6e937a669889a858f6afac3980045efdb256d01
        {
          _selectedKind = value;
          
          $(_form_id+" .dynamic").remove();
          
<<<<<<< HEAD
          if(_selectedKind === "Video" || _selectedKind === "Link")
=======
          if(_selectedKind == "Video" || _selectedKind == "Link")
>>>>>>> f6e937a669889a858f6afac3980045efdb256d01
          {
            _addFormField(_fields["linkField"]);
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
