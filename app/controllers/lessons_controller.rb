require 'nokogiri'
require 'open-uri'

class LessonsController < ApplicationController
  include LessonsHelper
  before_filter :get_skill_tree, :only => [:new,:edit,:show]
  layout "sidebar"

  def index
    authorize! :index, Lesson
  end

  def new

    @lesson = Lesson.new

    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      @skill_lesson = SkillLesson.new
      @skill_lesson.list_scope = (params[:list_scope].nil?) ? 1 : params[:list_scope]
      @skill_lesson.skill_id = @skill.id
    end
    
    authorize! :create, @lesson
  end

  def create

    @lesson = Lesson.new(params[:lesson])

    authorize! :create, @lesson

    if(params[:skill_lesson])
      @skill_lesson = @lesson.skill_lessons.build(params[:skill_lesson])
      @skill = @skill_lesson.skill

      if(@lesson.save)
       redirect_path =  categorized_lesson_path(@skill.slug,@lesson.id)
      end

    elsif @lesson.save

      redirect_path = lesson_path(@lesson)
    end

    if(@lesson.valid?)
      redirect_to redirect_path, :flash => { :success => "Lesson Added."}
    else
      render :new
    end

  end

  def edit
    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      @lesson = @skill.lessons.find(params[:id])
    else
      @lesson = Lesson.find(params[:id])
    end

    authorize! :update, @lesson
  end

  def update
    @lesson = Lesson.find(params[:id])
    authorize! :update, @lesson

    if params[:skill]
      @skill = Skill.find(params[:skill][:id]);
    end

    if @lesson.update_attributes(params[:lesson])
      if @skill
        redirect_to categorized_lesson_path(@skill.slug,@lesson)
      elsif
        redirect_to lesson_path
      end

    else
      render :edit
    end

  end

  def destroy
    redirect_path = training_index_path

    if params[:slug]
      @skill = Skill.find_by_slug(params[:slug]);
      skill_lesson = @skill.skill_lessons.find_by_lesson_id(params[:id])
      authorize! :destroy, skill_lesson

      skill_lesson.destroy
      redirect_path = named_skill_path(@skill.slug)
    elsif
      @lesson = Lesson.find(params[:id])
      authorize! :destroy, @lesson

      @lesson.destroy
    end


    respond_to do |format|
      format.html {redirect_to redirect_path, :flash => {:success => "Lesson Deleted."}}
      format.js { render :js => "window.location = '#{redirect_path}'"}
    end
  end

  def show
    if(params[:slug])
      @skill = Skill.find_by_slug!(params[:slug])

      @lesson = @skill.lessons.find(params[:id])
    else
      @lesson = Lesson.find(params[:id])
    end

    authorize! :show, @lesson

    @title = @lesson.title
  end

  def link_info
    if(params[:url] && params[:url].match(URL_REGEX))
      doc = Nokogiri::HTML(open(params[:url]))

      result = Hash.new

      result['title'] = doc.title
      result['description'] = "Not Found."

      doc.css('body p').each do |p|
        if(p.content.length > 200)
          result['description'] = p.content
          break
        end
      end


      respond_to do |format|
        format.json { render :json => ActiveSupport::JSON.encode(result) }
      end
    else
      head :bad_request
    end
  end
end
