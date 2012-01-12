class ChallengesController < ApplicationController
  #before_filter :check_admin_user, :except => :show
  layout "sidebar"
  
  def new
    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      
      @challenge = Challenge.new
    end
  end
  
  def create
    @skill = Skill.find_by_slug(params[:slug])
    @challenge = @skill.challenges.build(params[:challenge])
    
    if(@skill && @challenge.save)
      
      redirect_to training_path, :flash => { :success => "Challenge Added."}
    else
      render :new
    end
    
  end
  
  def edit
    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug])
      @challenge = @skill.challenges.find(params[:id])
    end
  end
  
  def update
    @challenge = Challenge.find(params[:id])
    
    if @challenge.update_attributes(params[:challenge])
      redirect_to training_challenge_path
    else
      @skill = Skill.find_by_slug(params[:slug])
      render :edit
    end
  end
  
  def destroy
    @challenge = Challenge.find(params[:id])
    @challenge.destroy
    
    redirect_to training_path, :flash => {:success => "Challenge Deleted!"}
  end
  
  def show
    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug])
      @challenge = @skill.challenges.find(params[:id])
    end
  end
end
