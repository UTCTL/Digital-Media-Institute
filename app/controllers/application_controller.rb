class ApplicationController < ActionController::Base
  protect_from_forgery

  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end

  # def signed_in?
  #   session[:user_id] != nil
  # end

  def get_skill_tree
    @skills = Skill.root.self_and_descendants
  end

  rescue_from CanCan::AccessDenied do |exception|
    if(!signed_in?)
      redirect_to(signin_path)
    else
      redirect_to(root_path)
    end
  end

  # helper_method :current_user
  # helper_method :signed_in?
end
