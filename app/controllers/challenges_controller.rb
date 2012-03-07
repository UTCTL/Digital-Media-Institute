class ChallengesController < ApplicationController
  before_filter :get_skill_tree, :only => [:index,:new,:edit,:show]
  before_filter :get_skill_nav, :only => [:index,:new,:edit,:show,:destroy]
  before_filter :get_related_challenges, :only => [:show,:edit]
  layout "sidebar"

  def get_skill_nav
    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug])
      @category = @skill.ancestors.last
    end
  end

  def get_related_challenges
    if @skill
      @challenge_list = SkillChallenge.where(:skill_id => @skill.id,:challenge_id => params[:id])
                                      .first
                                      .relatedChallenges

      @root_challenge = @challenge_list[0].challenge;
      @current_challenge = @challenge_list.find_by_challenge_id(params[:id]).challenge;
    else
      @root_challenge = @current_challenge = Challenge.find(params[:id])
    end

  end

  def index
    authorize! :index, Challenge
  end

  def new
    @current_challenge = Challenge.new
    authorize! :create, @current_challenge

    if(@skill)
      @skill_challenge = SkillChallenge.new
      @skill_challenge.skill_id = @skill.id
    end

  end

  def create
    @current_challenge = Challenge.new(params[:challenge])
    authorize! :create, @current_challenge

      if params[:skill_challenge]
        @skill_challenge = @current_challenge.skill_challenges.build(params[:skill_challenge])

        if @current_challenge.save
          @skill = @skill_challenge.skill
          redirect_path = categorized_challenge_path(@skill.slug,@current_challenge.id)
        end

      elsif @current_challenge.save

        redirect_path = challenge_path(@current_challenge)
      end

      if @current_challenge.valid?
        redirect_to redirect_path, :flash => { :success => "Challenge Added."}
      else
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
      render :edit
    end
  end

  def destroy
    redirect_path = training_index_path
    # this could probably be optimized better

    if @skill
      skill_challenge = @skill.skill_challenges.find_by_challenge_id(params[:id])
      authorize! :destroy, skill_challenge

      if skill_challenge.root? && skill_challenge.descendants.any?

        new_root = skill_challenge.descendants[0]
        new_root.title = skill_challenge.title
        new_root.save

        new_root.siblings.each do |node|

          node.move_to_child_of(new_root)
        end


        new_root.move_to_left_of(skill_challenge)
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
      format.js { render :js => "window.location = '#{redirect_path}'"}

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
