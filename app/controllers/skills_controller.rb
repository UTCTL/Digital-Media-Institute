class SkillsController < ApplicationController
  def index
    @skills = Skill.root.self_and_descendants
  end
  
  def show
    @skills = Skill.root.self_and_descendants
    
    if params[:slug]
      @skill = Skill.find_by_slug!(params[:slug])
    end
    
    render :layout => "sidebar" 
  end
  
  
end
