class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def signed_in?
    session[:user_id] != nil
  end
  
  def admin?
    signed_in? && current_user.admin
  end
  
  def check_admin_user
    if(!signed_in?)
      redirect_to(signin_path) 
    else
      redirect_to(root_path) unless admin?
    end
  end
  
  def get_skill_tree
    @skills = Skill.root.self_and_descendants
  end
  helper_method :current_user
  helper_method :signed_in?
  helper_method :admin?
end
