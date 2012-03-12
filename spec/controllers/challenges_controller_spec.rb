require 'spec_helper'

describe ChallengesController do
  render_views

  before(:each) do
    @challenge = FactoryGirl.create(:challenge)
    @challenge_attr = FactoryGirl.attributes_for(:challenge)

    @root = FactoryGirl.create(:skill);
    @skill_attr = FactoryGirl.attributes_for(:skill)

    @category_node = @root.children.create(@skill_attr.merge(:title => "Design"))
    @skill_node = @category_node.children.create(@skill_attr.merge(:title => "Photoshop"))
    @level_node = @skill_node.children.create(@skill_attr.merge(:title => "Beginner"))

    @challenge_category = @level_node.skill_challenges.create(:title => 'Test Category')
    @challenge.skill_challenges.create(:parent_id => @level_node.id)
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
          response.should_not have_selector("div",:id => "skillChallengeField")
        end
      end

      describe 'categorized challenge' do
        it 'includes skill_challenge form fields' do
          get :new, :slug => @level_node.slug
          response.should have_selector("div",:id => "skillChallengeField")
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

      context "logged in as admin" do

        before(:each) do
          test_sign_in(FactoryGirl.create(:admin_user))
        end

        describe "categorized challenge" do

          it "creates a challenge object" do
            lambda do
              post :create, :challenge => @challenge_attr, 
                  :skill_challenge => {:skill_id => @level_node.id}
            end.should change(Challenge, :count).by(1)

          end
          it "creates a skill_challenge object" do
            lambda do
              post :create, :challenge => @challenge_attr, 
                  :challenge_category => {:skill_id => @level_node.id, 
                                          :parent_id => @challenge_category.id
                                         }
            end.should change(SkillChallenge, :count).by(1)
          end

        end

        describe "uncategorized challenge" do
          it "creates a challenge object" do
            lambda do
              post :create, :challenge => @challenge_attr
            end.should change(Challenge, :count).by(1)

          end

          it "doesn't create a skill_challenge object" do
            lambda do
              post :create, :challenge => @challenge_attr
            end.should_not change(SkillChallenge, :count)
          end
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
