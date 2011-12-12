class LessonsController < ApplicationController
  def new
    @lesson = Lesson.new
    @lesson.list_scope = 1
    @lesson.skill_id = params[:skill_id]
  end
  
  def create
    skill = Skill.find(params[:lesson][:skill_id])
    @lesson = Lesson.new(params[:lesson])
    
    if(skill && @lesson.save)
      redirect_to "#{skills_path}/#{skill.slug}", :flash => { :success => "Lesson Added."}
    else
      render :new
    end
  end
end
