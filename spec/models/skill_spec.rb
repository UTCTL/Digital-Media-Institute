# == Schema Information
#
# Table name: skills
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  icon        :string(255)
#  slug        :string(255)
#  lft         :integer
#  rgt         :integer
#  parent_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  fulltitle   :string(255)
#

require 'spec_helper'

describe Skill do
  
  before(:each) do
    @root_node = FactoryGirl.create(:skill)
    @attr = { :title => "Test Node",:description => "this is a test description" }
  end
  
  it "should create new instance with valid attributes" do
    @root_node.children.create!(@attr)
  end
  
  
  describe "validations" do
    it "should require a title" do
      Skill.new(@attr.merge(:title => "")).should_not be_valid
    end
    
    it "should only have one root object" do
      extra_root = Skill.new(@attr)
      extra_root.should_not be_valid
    end
    
  end
  
  describe "associations" do
    
    it "has skill_challenges attribute" do
      @root_node.should respond_to(:skill_challenges)
    end
    
    it "has challenges attribute" do
      @root_node.should respond_to(:challenges)
    end
    it "has skill_lessons attribute" do
      @root_node.should respond_to(:skill_lessons)
    end
    
    it "has lessons attribute" do
      @root_node.should respond_to(:lessons)
    end
  end
  
  describe "association extensions" do
    
    describe "primary lessons" do
      it "returns lessons of proper list scope" do
        @lesson = FactoryGirl.create(:lesson);
        @skill_lesson = SkillLesson.create(:skill_id => @root_node.id, :lesson_id => @lesson.id, :list_scope => 1)
        @skill_lesson2 = SkillLesson.create(:skill_id => @root_node.id, :lesson_id => @lesson.id, :list_scope => 2)
        
        @root_node.lessons.list_scope(1).count.should == 1
      end
    end
    
    
  end
  
  describe "slug creation" do
    
    before(:each) do
      @c1_node = @root_node.children.create(@attr.merge(:title => "Child Node 1" ))
      @c2_node = @root_node.children.create(@attr.merge(:title => "Child Node 1" ))
      
      @c3_node = @c2_node.children.create(@attr.merge(:title => "Weinerschnizel" ))
    end
    
    it "should have a blank slug for root node" do
      
      @root_node.slug.should == ""
    end
    
    it "should not have a leading slash" do
     c4_node = @c2_node.children.create(@attr.merge(:title => "I like beans & corn @ the mall." ))
     
     c4_node.slug[0].should_not == '/'
    end
    
    it "should only include lowercase letters,-,/, and 0-9" do
      c4_node = @c2_node.children.create(@attr.merge(:title => "I like beans & corn @ the mall." ))
      
      c4_node.slug.match(/[^a-z0-9\-\/]+/).should be_nil
    end
    
    it "should create a unique slug" do
      
      @c1_node.slug.should_not == @c2_node.slug
      
    end
    
    it "should create a slug based on parent slug" do
      parent_node = Skill.find_by_id(@c3_node.parent_id)
      
      @c3_node.slug.match(parent_node.slug+'/').should_not be_nil
    end
    
    it "should have a full title" do
      
      @c3_node.fulltitle.should_not be_nil
    end
    
    it "should create a full title from titles of parent nodes" do
      parent_node = Skill.find(@c3_node.parent_id)
      
      @c3_node.fulltitle.match(parent_node.title).should_not be_nil
    end
  end
  
end
