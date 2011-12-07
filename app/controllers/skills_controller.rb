class SkillsController < ApplicationController
  def index
    @skills = Skill.root.self_and_descendants
  end
  
  def show
    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug])
    else
      @skill = Skill.find(params[:id])
    end
  end
end
