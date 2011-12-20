class SkillsController < ApplicationController
  def index
    @skills = Skill.root.self_and_descendants
  end
  
  def show
    @skills = Skill.root.self_and_descendants
    
    if params[:slug]
      @skill = Skill.find_by_slug!(params[:slug])
      
      title_array = @skill.self_and_ancestors
      title_array.shift
      
      @title = title_array.map {|i| i = i.title }.join(" \u27A2 ")
    end
    
    render :layout => "sidebar" 
  end
  
  def show_lesson
    
    
    if(params[:slug])
      @skill = Skill.find_by_slug!(params[:slug])
      
      @lesson = @skill.lessons.find(params[:lesson_id])
      
      @title = @lesson.title
      
      @video_id = @lesson.link.match(/([0-9]+)$/)[0]
    end
    
    render :layout => "sidebar"
  end
  
  def show_challenge
  end
end
