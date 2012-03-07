class SkillsController < ApplicationController
  before_filter :find_by_slug, :only => [:show]
  before_filter :get_skill_tree, :only => [:index, :show]
  load_and_authorize_resource :except => [:organize]

  def index
    respond_to do |format|
      format.html
      format.json { render :json => @skills.to_json }
    end
  end

  def show
    if @skill.level == 2
      @category = @skill
      render :layout => "sidebar" 
    else
      redirect_to named_skill_path(@skill.ancestors.last.slug)
    end
  end

  def create
    @skill.save
  end

  def update

    @skill.update_attributes(params[:skill]);

  end

  def destroy

    @skill.destroy
  end

  def organize
    authorize! :organize, Skill

  end

  def find_by_slug
    @skill = Skill.find_by_slug!(params[:slug])

  end
end
