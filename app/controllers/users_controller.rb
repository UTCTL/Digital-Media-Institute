class UsersController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def new

  end

  def create
    @user.role = "user"

    if @user.save
      redirect_to root_path, :notice => "Welcome to Digital Media Training!"
    else
      render 'new'
    end
  end

  def update
    if params[:user][:role]
      authorize! :change_role, @user
      @user.role = params[:user][:role]
    end

    @user.update_attributes(params[:user]);


  end

end
