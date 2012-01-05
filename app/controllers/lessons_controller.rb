class LessonsController < ApplicationController
  before_filter :check_admin_user, :except => :show
  layout "sidebar"
  
  def new
    
    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      
      @lesson = Lesson.new
      @lesson.list_scope = (params[:list_scope].nil?) ? 1 : params[:list_scope]  
    end
  end
  
  def create
    @skill = Skill.find_by_slug(params[:slug])
    @lesson = @skill.lessons.new(params[:lesson])
    
    if(@skill && @lesson.save)
      
      redirect_to training_path, :flash => { :success => "Lesson Added."}
    else
      render :new
    end
  end
  
  def edit
    @skill = Skill.find_by_slug(params[:slug])
    @lesson = @skill.lessons.find(params[:id])
    
    
  end
  
  def update
    @lesson = Lesson.find(params[:id])
    
    if @lesson.update_attributes(params[:lesson])
      redirect_to training_lesson_path
    else
      @skill = Skill.find_by_slug(params[:slug])
      render :edit
    end
    
  end
  
  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    
    redirect_to training_path, :flash => {:success => "Lesson Deleted."}
  end
  
  def show
    if(params[:slug])
      @skill = Skill.find_by_slug!(params[:slug])
      
      @lesson = @skill.lessons.find(params[:id])
      
      @title = @lesson.title
      
      @video_id = @lesson.link.match(/([0-9]+)$/)[0]
    end
  end
end
