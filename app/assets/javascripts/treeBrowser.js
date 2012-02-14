var treeList = function(spec){
  var _data = spec.data || [];
  var _selectedIndex = -1;
  var _parentTreeBrowser = spec.parentTreeBrowser;
  var _listID = _.uniqueId('list_');
  var _listObj;

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
      _listObj.children().eq(_selectedIndex).addClass("selected");
  };

  that.getSelectedItem = function(){ return _data[_selectedIndex]; };

  that.getListID = function(){ return _listID; };

  that.render = function(){
    _listObj = $("<ul id=\""+_listID+"\"/>");

    for(var i=0; i < _data.length; i++){
     _listObj.append("<li class=\"listItem\">"+_data[i].title+"</li>");
    }

    _listObj.append("<li class=\"addButton\">+ Add</li>");

    return _listObj;
  }

  return that;
};

var treeBrowser = function(spec){
  var _root;
  var _groupedData;
  var _lists = [];
  var _container = spec.container;
  var _form = spec.form.detach();

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

      var newList = treeList({ data: _groupedData[parent_id], parentTreeBrowser:this });
      _lists.push(newList);

      var child = newList.render().addClass("level"+this.currentLevel()).css("top",top);
      _container.append(child);
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

  that.maxLevel = function(){ return spec.maxLevel; };

  that.currentLevel = function(){ return _lists.length; }


  _container.on("click","li.listItem", function(){
    var index = $(this).index();
    var listID = $(this).parent().attr("id");

    var list = _.find(_lists, function(obj){ return obj.getListID() == listID });
    list.setSelectedIndex(index);

    that.popToList(list);
    that.pushList(list.getData()[index].id);

  });

  return that;
};

