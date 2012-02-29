class SubmissionsController < ApplicationController
  load_and_authorize_resource :except => :destroy

  def create
    @submission.save
    render :create, :layout => false
  end

  def destroy
    @answerable = find_answerable
    @submission = @answerable.submissions.find(params[:id])
    authorize! :destroy, @submission

    @submission.destroy
  end

  private

  def find_answerable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
