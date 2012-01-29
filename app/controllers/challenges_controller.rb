class ChallengesController < ApplicationController
  before_filter :check_admin_user, :except => :show
  before_filter :get_skill_tree, :only => [:new,:edit,:show]

  layout "sidebar"

  def index

  end

  def new
    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      @skill_challenge = SkillChallenge.new
      @skill_challenge.skill_id = @skill.id
      if params[:parent_id]
        @skill_challenge.parent_id = params[:parent_id]
      end
    end

    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.new(params[:challenge])

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
  end

  def update
    @challenge = Challenge.find(params[:id])

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
      skill_challenge.destroy
      redirect_path = named_skill_path(@skill.slug)
    elsif

      @challenge = Challenge.find(params[:id])
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


  end
end
