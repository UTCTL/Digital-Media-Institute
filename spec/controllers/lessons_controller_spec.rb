require 'spec_helper'

describe LessonsController do
  render_views
  
  before(:each) do
    @lesson = FactoryGirl.create(:lesson)
    @lesson_attr = FactoryGirl.attributes_for(:lesson)
    
    @root = FactoryGirl.create(:skill);
    @skill_attr = FactoryGirl.attributes_for(:skill)
    
    @category_node = @root.children.create(@skill_attr.merge(:title => "Design"))
    @skill_node = @category_node.children.create(@skill_attr.merge(:title => "Photoshop"))
    @level_node = @skill_node.children.create(@skill_attr.merge(:title => "Beginner"))
    
    @level_node.lessons << @lesson
  end
  
  describe 'GET show' do
    it 'responds successfully' do
      get :show, :id => @lesson
      response.should be_success
    end
  end
  
  describe 'GET new' do
    
    context "not logged in" do
      it "redirects to login page" do
        get :new
        response.should redirect_to(signin_path)
      end
    end
    
    context "logged in as non admin" do
      it 'redirects to training index' do
        test_sign_in(FactoryGirl.create(:user))
        
        get :new
        response.should redirect_to(root_path)
      end
    end
    
    context "logged in as admin" do
      
      before(:each) do
        test_sign_in(FactoryGirl.create(:admin_user))
      end
      
      it 'responds successfully' do
        get :new
        response.should be_success
      end
      
      describe 'uncategorized lesson' do
        it 'does not include skill_lesson form fields' do
          get :new
          response.should_not have_selector("input[type='hidden']",:name => "skill_lesson[skill_id]")
          response.should_not have_selector("input[type='hidden']",:name => "skill_lesson[list_scope]")
        end
      end
    
      describe 'categorized lesson' do
        it 'includes skill_id form fields' do
          get :new, :slug => @level_node.slug
          response.should have_selector("input[type='hidden']",:name => "skill_lesson[skill_id]")
          response.should have_selector("input[type='hidden']",:name => "skill_lesson[list_scope]")
        end
      end
    end
    
  end
  
  describe 'GET edit' do
    
    context "not logged in" do
      it "redirects to login page" do
        get :edit, :id => @lesson
        response.should redirect_to(signin_path)
      end
    end
    
    context "logged in as non admin" do
      it 'redirects to training index' do
        test_sign_in(FactoryGirl.create(:user))
        
        get :edit, :id => @lesson
        response.should redirect_to(root_path)
      end
    end
    
    context 'logged in as admin' do
      before(:each) do
        test_sign_in(FactoryGirl.create(:admin_user))
      end
    
      it 'responds successfully' do
        get :edit, :id => @lesson
        response.should be_success
      end
    end
    
  end
  
  describe 'POST create' do
    
    context "not logged in" do
      it "redirects to login page" do
        post :create, :lesson => @lesson_attr
        response.should redirect_to(signin_path)
      end
    end
    
    context "logged in as non admin" do
      it 'redirects to training index' do
        test_sign_in(FactoryGirl.create(:user))
        
        post :create, :lesson => @lesson_attr
        response.should redirect_to(root_path)
      end
    end
    
    context "logged in as admin" do
    
      before(:each) do
        test_sign_in(FactoryGirl.create(:admin_user))
      end
    
      describe 'uncategorized lesson' do
        it 'creates a lesson object' do
         
           lambda do
            post :create, :lesson => @lesson_attr
          end.should change(Lesson, :count).by(1)
        end
      
        it 'does not create skill_lesson object' do
          lambda do
            post :create, :lesson => @lesson_attr
          end.should_not change(SkillLesson, :count)
        end
      
        it 'redirects to show lesson page' do
          post :create, :lesson => @lesson_attr
        
          response.should redirect_to(lesson_path(assigns(:lesson)))
        end
      end
  
      describe 'categorized lesson' do
      
        it 'creates a lesson object' do
          lambda do
            post :create, :lesson => @lesson_attr, :skill_lesson => {:skill_id => @level_node.id, :list_scope => 1}
          end.should change(Lesson, :count).by(1)
        end
      
        it 'creates a skill_lesson object' do
          lambda do
            post :create, :lesson => @lesson_attr, :skill_lesson => {:skill_id => @level_node.id, :list_scope => 1}
          end.should change(SkillLesson, :count).by(1)
        end
      end
      
      describe "invalid lesson" do
        
        it "renders the new lesson form" do
          post :create, :lesson => @lesson_attr.merge(:title => "")
          response.should render_template(:new)
        end
        
      end
      
    end
  
  end
  
  describe 'PUT update' do
    
    before(:each) do
      @lesson_attr.merge(:title => "Changed Title") 
    end
    
    context "not logged in" do
      it "redirects to login page" do
        put :update, :lesson => @lesson_attr, :id => @lesson
        response.should redirect_to(signin_path)
      end
    end
    
    context "logged in as non admin" do
      it 'redirects to training index' do
        test_sign_in(FactoryGirl.create(:user))
        
        put :update, :lesson => @lesson_attr, :id => @lesson
        response.should redirect_to(root_path)
      end
    end
    
    context "logged in as admin" do
      
      before(:each) do
        test_sign_in(FactoryGirl.create(:admin_user))
      end
      
      describe "valid lesson object" do
        
        it "updates the lesson record" do
          put :update, :lesson => @lesson_attr, :id => @lesson
          @lesson.reload
          
          @lesson.title.should == @lesson_attr[:title]
        end
        
        it "redirects to lesson page" do
          put :update, :lesson => @lesson_attr, :id => @lesson
          response.should redirect_to(lesson_path(assigns(:lesson)))
        end
        
      end
      
      describe "invalid lesson object" do
        it "renders the edit form" do
          put :update, :lesson => @lesson_attr.merge(:title => ""), :id => @lesson
          response.should render_template(:edit)
        end
      end
    end
    
  end
  
  describe 'DELETE destroy' do
    
    context "logged in as admin user" do
      before(:each) do
        test_sign_in(FactoryGirl.create(:admin_user))
      end
      
      it 'removes lesson object' do
        lambda do
          delete :destroy, :id => @lesson
        end.should change(Lesson, :count).by(-1)
      end
      
      it 'removes all skill_lessons for the object' do
        delete :destroy, :id => @lesson
        
        SkillLesson.where("lesson_id = ?", @lesson.id).count.should == 0
      end
    end
    
  end

end