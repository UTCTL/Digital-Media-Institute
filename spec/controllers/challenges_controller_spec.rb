require 'spec_helper'

describe ChallengesController do
  
  before(:each) do
    @challenge = FactoryGirl.create(:challenge)
    @challenge_attr = FactoryGirl.attributes_for(:challenge)
    
    @root = FactoryGirl.create(:skill);
    @skill_attr = FactoryGirl.attributes_for(:skill)
    
    @category_node = @root.children.create(@skill_attr.merge(:title => "Design"))
    @skill_node = @category_node.children.create(@skill_attr.merge(:title => "Photoshop"))
    @level_node = @skill_node.children.create(@skill_attr.merge(:title => "Beginner"))
    
    @level_node.challenges << @challenge
  end
  
  describe 'GET show' do
    it 'responds successfully' do
      get :show, :id => @challenge
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
      
      describe 'uncategorized challenge' do
        it 'does not include skill_challenge form fields' do
          get :new
          response.should_not have_selector("input[type='hidden']",:name => "skill_challenge[skill_id]")
          response.should_not have_selector("select",:name => "skill_challenge[list_scope]")
        end
      end
    
      describe 'categorized challenge' do
        it 'includes skill_challenge form fields' do
          get :new, :slug => @level_node.slug
          response.should have_selector("input[type='hidden']",:name => "skill_challenge[skill_id]")
          response.should have_selector("select",:name => "skill_challenge[list_scope]")
        end
      end
    end
    
  end
  
  describe 'GET edit' do
    context "not logged in" do
      it "redirects to login page" do
        get :edit, :id => @challenge
        response.should redirect_to(signin_path)
      end
    end
    
    context "logged in as non admin" do
      it 'redirects to training index' do
        test_sign_in(FactoryGirl.create(:user))
        
        get :edit, :id => @challenge
        response.should redirect_to(root_path)
      end
    end
    
    context "logged in as admin" do
      
      before(:each) do
        test_sign_in(FactoryGirl.create(:admin_user))
      end
      
      it 'responds successfully' do
        get :edit, :id => @challenge
        response.should be_success
      end
    end
  end
  
  describe 'POST create' do
    context "not logged in" do
      it "redirects to login page" do
        post :create, :challenge => @challenge_attr
        response.should redirect_to(signin_path)
      end
    end
    
    context "logged in as non admin" do
      it 'redirects to training index' do
        test_sign_in(FactoryGirl.create(:user))
        
        post :create, :challenge => @challenge_attr
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe 'PUT update' do
    context "not logged in" do
      it "redirects to login page" do
        put :update, :challenge => @challenge_attr, :id => @challenge
        response.should redirect_to(signin_path)
      end
    end
    
    context "logged in as non admin" do
      it 'redirects to training index' do
        test_sign_in(FactoryGirl.create(:user))
        
        put :update, :challenge => @challenge_attr, :id => @challenge
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe 'DELETE destroy' do
    context "not logged in" do
      it "redirects to login page" do
        delete :destroy, :id => @challenge
        response.should redirect_to(signin_path)
      end
    end
    
    context "logged in as non admin" do
      it 'redirects to training index' do
        test_sign_in(FactoryGirl.create(:user))
        
        delete :destroy, :id => @challenge
        response.should redirect_to(root_path)
      end
    end
  end

end
