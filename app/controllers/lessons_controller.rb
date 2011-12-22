class LessonsController < ApplicationController
  before_filter :check_admin_user

  def new
    @lesson = Lesson.new
    @lesson.list_scope = 1
    @lesson.skill_id = params[:skill_id]
    
    if request.xhr?
      render :new, :layout => false
    else
      render :new
    end
  end
  
  def create
    @skill = Skill.find(params[:lesson][:skill_id])
    @lesson = Lesson.new(params[:lesson])
    
    if(@skill && @lesson.save)
      
      #redirect_to "#{skills_path}/#{skill.slug}", :flash => { :success => "Lesson Added."}
    else
      render :new
    end
  end
  
  def show
     if(params[:slug])
      @skill = Skill.find_by_slug!(params[:slug])
      
      @lesson = @skill.lessons.find(params[:id])
      
      @title = @lesson.title
      
      @video_id = @lesson.link.match(/([0-9]+)$/)[0]
    end
    
    render :layout => "sidebar"
  end
end
