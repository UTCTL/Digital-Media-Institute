require 'spec_helper'

describe LessonsController do
  
  before(:each) do
    root = FactoryGirl.create(:skill)
    category = root.children.create(FactoryGirl.attributes_for(:skill))
    level = category.children.create(FactoryGirl.attributes_for(:skill))
    @skill = level.children.create(FactoryGirl.attributes_for(:skill))
    
    @attr = FactoryGirl.attributes_for(:lesson)
    @lesson = @skill.lessons.create(@attr)
  end
  
  describe 'access control' do
   
    context 'when not logged in' do
      it 'denies access to new' do
        get :new, :slug => @skill.slug
        response.should redirect_to(signin_path)
      end
      it 'denies access to edit' do
        get :edit, :slug => @skill.slug, :id => 1
        response.should redirect_to(signin_path)
      end
      it 'denies access to create' do
        post :create, :slug => @skill.slug
        response.should redirect_to(signin_path)
      end
      it 'denies access to update' do
        put :update, :slug => @skill.slug, :id => 1
        response.should redirect_to(signin_path)
      end
      it 'denies access to destroy' do
        delete :destroy, :slug => @skill.slug, :id => 1
        response.should redirect_to(signin_path)
      end
    end
    
    context 'when logged in as a non-admin user' do
      
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
      end
      
      it 'denies access to new' do
        get :new, :slug => @skill.slug
        response.should redirect_to(root_path)
      end
      it 'denies access to edit' do
        get :edit, :slug => @skill.slug, :id => 1
        response.should redirect_to(root_path)
      end
      it 'denies access to create' do
        post :create, :slug => @skill.slug
        response.should redirect_to(root_path)
      end
      it 'denies access to update' do
        put :update, :slug => @skill.slug, :id => 1
        response.should redirect_to(root_path)
      end
      it 'denies access to destroy' do
        delete :destroy, :slug => @skill.slug, :id => 1
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe 'GET show' do
    render_views
    
    context 'anonymous users' do
      it 'should not show admin links' do
        
        get :show, :slug => @skill.slug, :id => @lesson
        
        response.should_not have_selector('div', :id => 'adminLinks');
      end
    end
    
    context 'logged in users' do
      it 'should not show admin links' do
        test_sign_in(FactoryGirl.create(:user))
        get :show, :slug => @skill.slug, :id => @lesson
        
        response.should_not have_selector('div', :id => "adminLinks");
      end
    end
    
    context 'admin users' do
      it 'should show admin links' do
        test_sign_in(FactoryGirl.create(:admin_user))
        get :show, :slug => @skill.slug, :id => @lesson
        
        response.should have_selector('div', :id => "adminLinks");
      end
    end
  end
  
  describe 'admin functions' do
    
    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:admin_user))
      
    end
    
    describe 'GET new' do
      it 'returns 200 status code' do
        get :new, :slug => @skill.slug 
        response.code.should eq('200')
      end
    end
  
    describe 'GET edit' do
      it 'returns 200 status code' do
        get :edit, :slug => @skill.slug, :id => @lesson.id
        response.code.should eq('200')
      end
    end
  
    context 'POST create' do
      describe 'success' do
        it 'creates a new lesson' do
          lambda do
            post :create, :slug => @skill.slug, :lesson => @attr
          end.should change(Lesson, :count).by(1)
        end
        it 'should redirect to the show lesson page' do
          post :create, :slug => @skill.slug, :lesson => @attr
          response.should redirect_to(training_lesson_path(:slug => @skill.slug, :id => assigns(:lesson).id))
        end
      end
      
      describe 'failure' do
        before(:each) do
          @attr = @attr.merge({title:''})
        end
        
        it 'doesn\'t create a lesson' do
          lambda do
            post :create, :slug => @skill.slug, :lesson => @attr
          end.should_not change(Lesson,:count)
        end
        it 'renders the new page' do
          post :create, :slug => @skill.slug, :lesson => @attr
          response.should render_template(:new)
        end
      end
    end
  
    describe 'PUT update' do
      
      describe 'success' do
        
        before(:each) do
          @attr = @attr.merge({:title => "New Title"})
        end
        
        it 'updates lesson attributes' do
          put :update, :slug => @skill.slug, :id => @lesson, :lesson => @attr
          @lesson.reload
          
          @lesson.title.should == @attr[:title]
        end
        it 'renders the show page' do
          put :update, :slug => @skill.slug, :id => @lesson, :lesson => @attr
          response.should redirect_to(training_lesson_path)
        end
      end
      
      describe 'failure' do
        
        before(:each) do
          @attr = @attr.merge({:title => ""})
        end
        
        it 'does not update lesson attributes' do
          put :update, :slug => @skill.slug, :id => @lesson, :lesson => @attr
          @lesson.reload
          
          @lesson.title.should_not == @attr[:title]
        end
        it 'renders the edit page' do
          put :update, :slug => @skill.slug, :id => @lesson, :lesson => @attr
          response.should render_template(:edit)
        end
      end
    end
  
    describe 'DELETE destroy' do
      describe 'success' do
        it 'removes the lesson' do
          lambda do
            delete :destroy, :slug => @skill.slug, :id => @lesson
          end.should change(Lesson,:count).by(-1)
        end
        it 'redirects to the skill page' do
          delete :destroy, :slug => @skill.slug, :id => @lesson
          response.should redirect_to(training_path)
        end
      end
    end
  end
end
