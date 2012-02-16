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
    this.render();
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

      var listItem = $( "<li class=\"listItem\" data-id=\""+_data[i].id+"\">"+_data[i].title+"</li>" );

      if(i == _selectedIndex){
        listItem.addClass("selected").append(adminLinks);
      }

      _listObj.append(listItem);

    }

    _listObj.append("<li class=\"addButton\">+ Add</li>");
    _parentTreeBrowser.sizeToFit();
  }


  return that;
};

var treeBrowser = function(spec){
  var _root;
  var _data;
  var _lists = [];
  var _container = spec.container;
  var _form = $("<li></li>");
  _form.append(spec.form.detach());

  var _formReplacedItem;
  var _editing = false;

  var getListObject = function(listItem){
    var listID = $(listItem).parentsUntil(_container,"ul").attr("id");

    return _.find(_lists, function(obj){ return obj.getListID() == listID });
  };

  var getListByParentID = function(parent_id){
    return _.find(_lists,function(obj){ return obj.getParentID() == parent_id });
  };

  var getChildren = function(parent_id){
    return _.filter(_data, function(obj){ return obj.parent_id == parent_id });
  };

  var indexForItem = function(item){
    var index = -1, found = false, i=0;

    while(!found && i < _data.length){
      if(item.id == _data[i].id){
        index = i;
        found = true;
      }
      else{
        i++;
      }
    }

    return index;
  };

  var that = {};

  that.loadData = function(){
    var owner = this;

    $.ajax({
           url: spec.dataPath+".json", 
           success: function(data){
             _root = data.shift();
             _data = data;
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

      var newList = treeList({ data: getChildren(parent_id), parent_id:parent_id, parentTreeBrowser:this });

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

  that.showForm = function(item,editing){
    var list = getListObject(item);
    _editing = editing;

    _form.insertBefore(item);
    _formReplacedItem = $(item).detach();
    
    if(_editing){
      var item_id = _formReplacedItem.attr("data-id");
      $("#"+spec.objName+"_form").attr("action",spec.dataPath+"/"+item_id);
      $("#"+spec.objName+"_title").val(_formReplacedItem.contents().eq(0).text());
    }
    else{
      $("#"+spec.objName+"_form").attr("action",spec.dataPath);
      $("#"+spec.objName+"_title").val('');
    }
    $("#"+spec.objName+"_parent_id").val(list.getParentID());
    $("#"+spec.objName+"_title").focus();
  };

  that.hideForm = function(){
    _form.replaceWith(_formReplacedItem);
  };

  that.addItem = function(item){
    var list;
    _data.push(item);

    if(list = getListByParentID(item.parent_id)){
      list.setData(getChildren(item.parent_id));
    }

  };

  that.removeItem = function(item){
    var index, list;

    index = indexForItem(item);

    if(index != -1){
      _data.splice(index,1);
    }

    if(list = getListByParentID(item.parent_id)){
      list.setSelectedIndex(-1);
      this.popToList(list);
      list.setData(getChildren(item.parent_id));
    }
  };

  that.updateItem = function(item){
    var index, list;

    index = indexForItem(item);

    if(index != -1){
      _data[index] = item;
    }

    if(list = getListByParentID(item.parent_id)){
      list.setData(getChildren(item.parent_id));
    }

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

  that.maxLevel = function(){ return spec.maxLevel; };

  that.currentLevel = function(){ return _lists.length; }
  that.getDataPath = function(){ return spec.dataPath; };


  _container.on("click","li.listItem", function(){
    var index = $(this).index();

    var list = getListObject(this);

    list.setSelectedIndex(index);

    that.popToList(list);
    that.pushList($(this).attr("data-id"));

  });

  _container.on("click","li.addButton", function(){
   that.showForm(this, false); 
  });

  _container.on("focus","#"+spec.objName+"_title", function(){
    this.select();
  });

  _container.on("blur","#"+spec.objName+"_title", function(){
    that.hideForm();
  });

  _container.on("submit","#"+spec.objName+"_form", function(event){
    event.preventDefault();

    var method = _editing ? "put":"post";

    $.ajax({url:this.action,data:$(this).serialize(), type:method});
  });

  _container.on("click", ".deleteLink", function(event){
    event.stopPropagation();
    event.preventDefault();
    
    var list = getListObject(this);

    if(confirm("Are you sure?")){
      $.ajax({url:that.getDataPath()+"/"+list.getSelectedItem().id,
             type:"delete"});
    }
  });

  _container.on("click", ".editLink", function(event){
    event.stopPropagation();
    event.preventDefault();

    that.showForm($(this).parents("li"),true);
  });
  return that;
};

