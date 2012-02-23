class SubmissionsController < ApplicationController
  load_and_authorize_resource

  def create
    @submission.save
    render :create, :layout => false
  end
end
