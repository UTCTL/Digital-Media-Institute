(function ($){

  $.fn.ajax_accordian = function() {

    var prevContainer;
    var currentContainer;
    var currentHeader;

    var content_onResult = function(data){
      if(currentHeader){
        var containerHeight = 0;

        var innerContent = $("<div class=\"inner_content\"></div>");
        innerContent.html(data);

        currentContainer.empty();
        currentContainer.append(innerContent);

        $(currentHeader).after(currentContainer);

        if(prevContainer){
          // prevContainer.remove();
          prevContainer.addClass("remove");
          prevContainer.css("height",0)
        }

        // currentContainer.css("display","block");
        containerHeight = innerContent.height();
        console.log("height = "+containerHeight);


        setTimeout(function(){

          currentContainer.css("height",containerHeight+20)
        },0);
      }

    };

    var owner = this;
    return this.each(function(){
      $(this).click(function(){
        if(currentHeader === this)
          return false;


        currentHeader = this;

        //this is a global variable
        //initCallback is set in the view that is loaded into the accordian
        initCallback = null;

        prevContainer = currentContainer;
        currentContainer = $("<div class=\"accordian_content\"></div>");

        currentContainer.on("webkitTransitionEnd",function(){
          if($(this).hasClass("remove")){
            $(this).remove();
          }

          //Global, this is a hack to get my javascript forms to work
          if(typeof initCallback === "function")
            initCallback();

          $(".inner_content",this).css("visibility","visible");
        });

        currentContainer.on("click",".challenge-subnav",function(){
          $.ajax({url:this.href,dataType:"html",success:content_onResult});
          return false;
        });

        $.ajax({url:this.href,dataType:"html",success:content_onResult});

        return false;

      });
    });
  };
})(jQuery);
