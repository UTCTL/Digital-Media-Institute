class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
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
    redirect_to(root_path) unless admin?
  end
  
  helper_method :current_user
  helper_method :signed_in?
  helper_method :admin?
end
