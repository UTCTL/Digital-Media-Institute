var treeList = function(spec){
  var _data = spec.data || [];
  var _selectedIndex = -1;
  var _parentTreeBrowser = spec.parentTreeBrowser;
  var _listID = _.uniqueId('list_');
  var _listObj = $("<ul id=\""+_listID+"\"/>");

  var adminLinks =$( "<div class=\"editTreeLinks\"><a href=\"#\" class=\"deleteLink\">Delete</a> | <a href=\"#\" class=\"editLink\">Edit</a></div>" );

  var that = {};

  that.getData = function(){
    return _data;
  };

  that.setData = function(value){
    _data = value;
  };

  that.getSelectedIndex = function(){ return _selectedIndex; };

  that.setSelectedIndex = function(value){
    if(_selectedIndex !== value){

      if(_selectedIndex != -1)
        _listObj.children().eq(_selectedIndex).removeClass("selected");

      _selectedIndex = value;
    }

    if(_selectedIndex != -1)
      _listObj.children().eq(_selectedIndex).addClass("selected").append(adminLinks);
  };

  that.getSelectedItem = function(){ return _data[_selectedIndex]; };

  that.getListID = function(){ return _listID; };

  that.getParentID = function(){ return spec.parent_id };

  that.getDisplayObject = function(){ return _listObj };

  that.render = function(){
    _listObj.html('');

    for(var i=0; i < _data.length; i++){

      var listItem = $( "<li class=\"listItem\">"+_data[i].title+"</li>" );

      if(i == _selectedIndex){
        listItem.addClass("selected").append(adminLinks);
      }

      _listObj.append(listItem);

    }


    _listObj.append("<li class=\"addButton\">+ Add</li>");
    
    _parentTreeBrowser.sizeToFit();
  }

  $(".deleteLink",adminLinks).on("click", function(event){
    event.stopPropagation();

    if(confirm("Are you sure?")){
      $.ajax({url:_parentTreeBrowser.getDataPath()+"/"+that.getSelectedItem().id,
             type:"delete"});
    }
    return false;
  });

  $(".editLink",adminLinks).on("click", function(event){
    event.stopPropagation();
    return false;
  });

  return that;
};

var treeBrowser = function(spec){
  var _root;
  var _groupedData;
  var _lists = [];
  var _container = spec.container;
  var _form = spec.form.detach();

  var getListObject = function(listItem){
    var listID = $(listItem).parent().attr("id");

    return _.find(_lists, function(obj){ return obj.getListID() == listID });
  };

  var getListByParentID = function(parent_id){
    return _.find(_lists,function(obj){ return obj.getParentID() == parent_id });
  };

  var that = {};

  that.loadData = function(){
    var owner = this;

    $.ajax({
           url: spec.dataPath+".json", 
           success: function(data){
             _root = data.shift();
             _groupedData = _.groupBy(data,'parent_id');
             owner.pushList(_root.id);
           },
           error:function() {
             console.log("Unable to load remote data.");
           }
    });
  };

  that.pushList = function(parent_id){
    if(this.currentLevel() < this.maxLevel()){
      var top = 0;

      $("li.selected",_container).each(function(){ top += $(this).position().top });

      var newList = treeList({ data: _groupedData[parent_id], parent_id:parent_id, parentTreeBrowser:this });

      _lists.push(newList);

      var child = newList.getDisplayObject().addClass("level"+this.currentLevel()).css("top",top);

      _container.append(child);
      newList.render();
    }
  };

  that.popList = function(){
    var list = _lists.pop();
    $("#"+list.getListID()).remove();
  };

  that.popToList = function(list){

    while(_lists[_lists.length - 1] !== list){
     this.popList();
    }
  };

  that.showErrors = function(errors){};
  that.hideErrors = function(){};
  that.addItem = function(item){
    _groupedData[item.parent_id].push(item);
    this.updateListDisplay(item.parent_id);
  };

  that.sizeToFit = function(){
    var max = 0;

    for(var i=0;i< _lists.length; i++){
      var list = _lists[i].getDisplayObject();
      var desiredHeight = list.position().top + list.outerHeight();

      if(desiredHeight > max){
        max = desiredHeight
      }
    }

    _container.css("height",max);
    
  };

  that.updateListDisplay = function(parent_id){
    var list;

    if(list =  getListByParentID(parent_id)){
      list.render();
    }

  };

  that.maxLevel = function(){ return spec.maxLevel; };

  that.currentLevel = function(){ return _lists.length; }
  that.getDataPath = function(){ return spec.dataPath; };


  _container.on("click","li.listItem", function(){
    var index = $(this).index();

    var list = getListObject(this);

    list.setSelectedIndex(index);

    that.popToList(list);
    that.pushList(list.getData()[index].id);

  });

  _container.on("click","li.addButton", function(){
    var list = getListObject(this);

    $(this).replaceWith(_form);
    $("#"+spec.objName+"_parent_id").val(list.getParentID());
    $("#"+spec.objName+"_title").val('');
    $("#"+spec.objName+"_title").focus();
  });

  _container.on("blur","#"+spec.objName+"_title", function(){
    _form.replaceWith("<li class=\"addButton\">+ Add</li>");
  });

  return that;
};

