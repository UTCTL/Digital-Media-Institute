require 'nokogiri'
require 'open-uri'

class LessonsController < ApplicationController
  include LessonsHelper
  before_filter :check_admin_user, :except => :show
  layout "sidebar"
  
  def new
    
    if(params[:slug])
      @skill = Skill.find_by_slug(params[:slug])
      
      @lesson = Lesson.new
      @lesson.list_scope = (params[:list_scope].nil?) ? 1 : params[:list_scope]  
    end
  end
  
  def create
    @skill = Skill.find_by_slug(params[:slug])
    @lesson = @skill.lessons.new(params[:lesson])
    
    if(@skill && @lesson.save)
      
      redirect_to training_path, :flash => { :success => "Lesson Added."}
    else
      render :new
    end
  end
  
  def edit
    @skill = Skill.find_by_slug(params[:slug])
    @lesson = @skill.lessons.find(params[:id])
    
    
  end
  
  def update
    @lesson = Lesson.find(params[:id])
    
    if @lesson.update_attributes(params[:lesson])
      redirect_to training_lesson_path
    else
      @skill = Skill.find_by_slug(params[:slug])
      render :edit
    end
    
  end
  
  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    
    redirect_to training_path, :flash => {:success => "Lesson Deleted."}
  end
  
  def show
    if(params[:slug])
      @skill = Skill.find_by_slug!(params[:slug])
      
      @lesson = @skill.lessons.find(params[:id])
      
      @title = @lesson.title
      
    end
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
