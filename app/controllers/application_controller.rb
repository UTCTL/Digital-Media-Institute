class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'subpage'


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

end
