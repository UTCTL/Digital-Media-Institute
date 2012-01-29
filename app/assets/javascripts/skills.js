var skillsPage = function(){
  var _show = false;
  return {
    init: function(){
      var owner = this;
      $(".indexLink").click(function(){
        owner.toggleIndexPopOver();
        return false;
      });

      $(document).on("click",function(){
        if(_show)
          owner.toggleIndexPopOver();
      });

      $("#training_index_popover").click(function(e){ 
        e.stopPropagation();
      });


      $(document).on("webkitTransitionEnd","#training_index_popover", function(e){
        if($(this).css("opacity") == 0)
          $(this).css("visibility","hidden");
      });

    },
    toggleIndexPopOver: function() {

      _show = !_show;
      var toOpacity = _show ? 1:0;

      $("#training_index_popover").css("visibility","visible");
      $("#training_index_popover").css("opacity",toOpacity);

    }
  };
}();
