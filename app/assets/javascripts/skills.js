var skillsPage = function(){
	
	return {
		init: function(){
			
			var owner = this;
			$("a.addNewLesson").on("ajax:success",this.showSlidePage);
			
			$("#new_lesson").live("ajax:success",this.hideSlidePage);
			
			$(".overlay").on("webkitTransitionEnd", function(){
				if($(this).css("opacity") == 0)
				{
					$(this).css("visibility","hidden");
				}
			});
			
			
			$(".overlay").click(function(){
				owner.hideSlidePage();
			});
			
			$(".overlay").css("visibility","hidden");
		},
		showSlidePage: function(evt,data){
			
			$(".overlay").css("visibility","visible");
			$(".overlay").addClass("show");
			
			$(".slidePage").html(data);
			$(".slidePage").addClass("open");
		},
		hideSlidePage: function(){
			$(".overlay").removeClass("show");
			
			//$(".slidePage").html("");
			$(".slidePage").removeClass("open");
		}
		
	};
}();