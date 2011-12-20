class LessonsController < ApplicationController
  before_filter :admin_user

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
  
  private
  
  def admin_user
    redirect_to(root_path) unless admin?
  end
end
