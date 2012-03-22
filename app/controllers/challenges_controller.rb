class ChallengesController < ApplicationController
  before_filter :get_skill_tree, :only => [:index,:new,:edit,:show]
  before_filter :get_skill_nav, :only => [:index,:new,:edit,:show,:destroy]
  before_filter :get_related_challenges, :only => [:show,:edit]
  layout "content_only", :unless => :index

  def get_skill_nav
    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug])
      @category = @skill.ancestors.last
    end
  end

  def get_related_challenges
    if @skill
      @current_challenge = @skill.challenges.find(params[:id])

      @challenge_list = @current_challenge.relatedChallenges
    else
      @current_challenge = Challenge.find(params[:id])
    end

  end

  def index
    authorize! :index, Challenge
    render :index, :layout => "training_page"
  end

  def new
    @current_challenge = Challenge.new
    authorize! :create, @current_challenge

    if(@skill)
      @challenge_category = @skill.skill_challenges.build
    end

  end

  def create
    @current_challenge = Challenge.new(params[:challenge])
    authorize! :create, @current_challenge

      if params[:challenge_category]

        if params[:challenge_category][:parent_id].present?
          skill_challenge = @current_challenge.skill_challenges.build(params[:challenge_category])
        else
          parent = SkillChallenge.create!(params[:challenge_category])
          skill_challenge = @current_challenge.skill_challenges.build(:parent_id => parent.id,
                                                                      :skill_id => parent.skill_id)
        end


        if @current_challenge.save
          @skill = skill_challenge.skill
          redirect_path = categorized_challenge_path(@skill.slug,@current_challenge.id)
        end

      elsif @current_challenge.save

        redirect_path = challenge_path(@current_challenge)
      end

      if @current_challenge.valid?
        respond_to do |format|
          format.html { redirect_to redirect_path, :flash => { :success => "Challenge Added."} }
          format.js { render :js => "parent.challengeCreateCallback()"}
        end
      else
        @category = @skill.ancestors.last
        render :new
      end

  end

  def edit

    authorize! :update, @current_challenge
  end

  def update
    @current_challenge = Challenge.find(params[:id])
    authorize! :update, @current_challenge

    if params[:skill]
      @skill = Skill.find(params[:skill][:id]);
    end


    if @current_challenge.update_attributes(params[:challenge])

      if @skill
        redirect_to categorized_challenge_path(@skill.slug,@current_challenge)
      elsif
        redirect_to challenge_path
      end

    else
      @category = @skill.ancestors.last
      render :edit
    end
  end

  def destroy
    redirect_path = training_index_path
    # this could probably be optimized better

    if @skill
      skill_challenge = @skill.skill_challenges.find_by_challenge_id(params[:id])
      authorize! :destroy, skill_challenge

      if skill_challenge.siblings.empty?

        skill_challenge.root.destroy
      end


      skill_challenge.destroy
      redirect_path = categorized_challenge_index_path(@skill.slug)
    elsif

      @current_challenge = Challenge.find(params[:id])
      authorize! :destroy, @current_challenge

      @current_challenge.destroy
    end

    respond_to do |format|
      format.html {redirect_to redirect_path, :flash => {:success => "Challenge Deleted!"}}
      format.js { render :js => "parent.challengeDestroyCallback('#{redirect_path}')"}

    end
  end

  def show

    authorize! :show, @current_challenge

    if current_user
      @submission = @current_challenge.submissions.first
      @submission ||= @current_challenge.submissions.build(:user_id => current_user.id)
    end
  end


end
