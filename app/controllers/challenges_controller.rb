class ChallengesController < ApplicationController
  before_filter :get_skill_tree, :only => [:new,:edit,:show]
  layout "sidebar"

  def index
    authorize :index, Challenge
  end

  def new
    @challenge = Challenge.new
    authorize! :create, @challenge

    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      @skill_challenge = SkillChallenge.new
      @skill_challenge.skill_id = @skill.id
      if params[:parent_id]
        @skill_challenge.parent_id = params[:parent_id]
      end
    end

  end

  def create
    @challenge = Challenge.new(params[:challenge])
    authorize! :create, @challenge

      if params[:skill_challenge]
        @skill_challenge = @challenge.skill_challenges.build(params[:skill_challenge])
        @skill = @skill_challenge.skill

        if @challenge.save
          redirect_path = categorized_challenge_path(@skill.slug,@challenge.id)
        end

      elsif @challenge.save

        redirect_path = challenge_path(@challenge)
      end

      if @challenge.valid?
        redirect_to redirect_path, :flash => { :success => "Challenge Added."}
      else
        render :new
      end

  end

  def edit
    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug])
      @challenge = @skill.challenges.find(params[:id])
    else
      @challenge = Challenge.find(params[:id])
    end

    authorize! :update, @challenge
  end

  def update
    @challenge = Challenge.find(params[:id])
    authorize! :update, @challenge

    if params[:skill]
      @skill = Skill.find(params[:skill][:id]);
    end


    if @challenge.update_attributes(params[:challenge])

      if @skill
        redirect_to categorized_challenge_path(@skill.slug,@challenge)
      elsif
        redirect_to challenge_path
      end

    else
      render :edit
    end
  end

  def destroy
    redirect_path = training_index_path

    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug])
      skill_challenge = @skill.skill_challenges.find_by_challenge_id(params[:id])
      authorize! :destroy, skill_challenge

      skill_challenge.destroy
      redirect_path = named_skill_path(@skill.slug)
    elsif

      @challenge = Challenge.find(params[:id])
      authorize! :destroy, @challenge

      @challenge.destroy
    end

    respond_to do |format|
      format.html {redirect_to redirect_path, :flash => {:success => "Challenge Deleted!"}}
      format.js { render :js => "window.location = '#{redirect_path}'"}

    end
  end

  def show
    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug])
      @challenge_list = SkillChallenge.where(:skill_id => @skill.id,:challenge_id => params[:id])
                                      .first
                                      .relatedChallenges

      @root_challenge = @challenge_list[0].challenge;
      @current_challenge = @challenge_list.find_by_challenge_id(params[:id]).challenge;
    else
      @root_challenge = @current_challenge = Challenge.find(params[:id])
    end
    
    if current_user
      @submission = Submission.where(:user_id => current_user.id,
                                     :challenge_id => @current_challenge.id).first
      @submission ||= Submission.new(:user_id => current_user.id,:challenge_id => @current_challenge.id)
    end

    authorize! :show, @current_challenge


  end
end
