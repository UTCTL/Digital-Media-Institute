require 'nokogiri'
require 'open-uri'

class LessonsController < ApplicationController
  include LessonsHelper
  before_filter :check_admin_user, :except => :show
  layout "sidebar"
  
  def index
  end
  
  def new
    
    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      @skill_lesson = SkillLesson.new
      @skill_lesson.list_scope = (params[:list_scope].nil?) ? 1 : params[:list_scope]
      @skill_lesson.skill_id = @skill.id
    end
    
     @lesson = Lesson.new
  end
  
  def create
    
    @lesson = Lesson.new(params[:lesson])
    if(params[:skill_lesson])
      @skill_lesson = @lesson.skill_lessons.build(params[:skill_lesson])
      @skill = @skill_lesson.skill
      
      if(@lesson.save)
       
       redirect_to categorized_lesson_path(@skill.slug,@lesson.id), :flash => { :success => "Lesson Added."}
      else
       render :new
      end
       
    elsif(@lesson.save)
      redirect_to lesson_path(@lesson), :flash => { :success => "Lesson Added."}
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
    
  end
  
  def update
    @lesson = Lesson.find(params[:id])
    
    if @lesson.update_attributes(params[:lesson])
      redirect_to lesson_path
    else
      #@skill = Skill.find_by_slug(params[:slug])
      render :edit
    end
    
  end
  
  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    
    redirect_to training_index_path, :flash => {:success => "Lesson Deleted."}
  end
  
  def show
    if(params[:slug])
      @skill = Skill.find_by_slug!(params[:slug])
      
      @lesson = @skill.lessons.find(params[:id])
    else
      @lesson = Lesson.find(params[:id])
    end
    
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
