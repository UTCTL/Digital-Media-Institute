(function ($){

  var prevContainer;
  var currentContainer;
  var currentHeader;
  var addButton;
  var auxViewVisible = false;
  var primaryCallback;
  var auxCallback;

  var headerClickHandler = function(){
    if(currentHeader === this)
      return false;

    currentHeader = this;

    prevContainer = currentContainer;
    var containerHTML = "<div class=\"accordian_content\">";
    containerHTML    += "<div class=\"inner_content\">";
    containerHTML    += "<div class=\"accordian-view primary\"></div>"
    containerHTML    += "<div class=\"accordian-view aux\"></div>"
    containerHTML    += "<div class=\"clear\"</div>";
    containerHTML    += "</div></div>";

    currentContainer = $(containerHTML);

    //TODO Needs update to support other browsers
    currentContainer.on("webkitTransitionEnd",function(){

      if($(this).hasClass("remove")){
        $(this).remove();
      }



      // $(".inner_content",this).css("visibility","visible");
    });

    $(".inner_content",currentContainer).on("webkitTransitionEnd", function(){

      if(typeof auxCallback === "function"){

        if(auxViewVisible){
          auxCallback();
        }
        else{
          $(".aux",currentContainer).empty();
        }
      }

    });

    currentContainer.on("click",".challenge-subnav",function(){
      $.ajax({url:this.href,dataType:"html",success:content_onResult});
      return false;
    });

    $.ajax({url:this.href,dataType:"html",success:content_onResult});

    return false;
  }

  var editClickHandler = function(){

    $.ajax({url:this.href,dataType:"html",success:auxContent_onResult});

    return false;
  };

  var backClickHandler = function(){
    auxViewVisible = false;

    $.ajax({url:this.href,dataType:"html",success:content_onResult});
    return false;
  };

  var content_onResult = function(data){
    if(currentHeader){
      var containerHeight = 0;

      $(".primary",currentContainer).html(data);

      $(currentHeader).after(currentContainer);

      if(prevContainer){
        prevContainer.css("height",0);
      }

      containerHeight = $(".inner_content",currentContainer).height();
      console.log("height = "+containerHeight);

      if(typeof primaryCallback === "function")
        primaryCallback();

      $(".inner_content",currentContainer).css("left",0);
      //height wasn't registering correctly,this pushes it to the next render
      setTimeout(function(){

        currentContainer.css("height",containerHeight)
      },0);
    }

  };

  var auxContent_onResult = function(data){

    auxViewVisible = true;
    $(".aux",currentContainer).html(data);

    var containerHeight = $(".inner_content",currentContainer).height();

    $(".inner_content",currentContainer).css("left",-675);

    setTimeout(function(){

      currentContainer.css("height",containerHeight)
    },0);

  };

  var methods = {
    init : function(options){
      addButton = $(".add-button",this);
      this.on("click",".edit-link",editClickHandler);
      this.on("click",".accordian-header",headerClickHandler);
      this.on("click",".back-link",backClickHandler);

      return this;
    },
    addHeader: function(options){
      var newHeader = "<a href=\""+options.link+"\" class=\"accordian-header\">"+options.title+"</a>";

      if(addButton.length !== 0){
        addButton.before(newHeader);
      }
      else{
        this.append(newHeader);
      }

    },
    removeHeader: function(){
      $(currentHeader).fadeOut(500,function(){ $( this ).remove() });
      methods["close"].apply(this);
    },
    close: function(){
      
      if(currentContainer){
        currentContainer.addClass("remove");
        currentContainer.css("height",0)
      }
    },
    setPrimaryCallback: function(callback){
    
      primaryCallback = callback;
    },
    setAuxCallback: function(callback){
    
      auxCallback = callback;
    }
  };

  $.fn.ajax_accordian = function(method) {
    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.ajax_accordian' );
    }
  };
})(jQuery);
