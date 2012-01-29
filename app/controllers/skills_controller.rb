class SkillsController < ApplicationController
  before_filter :get_skill_tree, :only => [:index,:show]

  def index
  end
  
  def show
    
    if params[:slug]
      @skill = Skill.find_by_slug!(params[:slug])
    end
    
    render :layout => "sidebar" 
  end
  
  
end
