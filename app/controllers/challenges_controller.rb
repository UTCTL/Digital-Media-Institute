class ChallengesController < ApplicationController
  before_filter :check_admin_user, :except => :show
  layout "sidebar"

  def index

  end

  def new
    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      @skill_challenge = SkillChallenge.new
      @skill_challenge.skill_id = @skill.id
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
        redirect_to categorized_challenge_path(@skill.slug,@lesson)
      elsif
        redirect_to challenge_path
      end

    else
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
    else
      @challenge = Challenge.find(params[:id])
    end
  end
end
