class UsersController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def new

  end

  def update

    if params[:user].has_key?(:role)
      authorize! :change_role, @user
      @user.role = params[:user][:role]
      @user.save(:validate => false)
    end



  end

end
