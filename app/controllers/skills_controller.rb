class SkillsController < ApplicationController
  before_filter :get_skill_tree, :only => [:index, :show]
  before_filter :check_admin_user, :only => [:organize]

  def index
    respond_to do |format|
      format.html
      format.json { render :json => @skills.to_json }
    end
  end

  def show

    if params[:slug]
      @skill = Skill.find_by_slug!(params[:slug])
    end

    render :layout => "sidebar" 
  end

  def create
    @skill = Skill.create(params[:skill])
    

  end

  def update
    @skill = Skill.find(params[:id])

    @skill.update_attributes(params[:skill]);

  end

  def destroy
    @skill = Skill.find(params[:id])

    @skill.destroy
  end

  def organize

  end
end
