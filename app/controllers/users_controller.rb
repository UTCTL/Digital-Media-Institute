class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_path, :notice => "Welcome to Digital Media Training!"
    else
      render 'new'
    end
  end
  
  def update
    
  end
  
  def destroy
    
  end
end
