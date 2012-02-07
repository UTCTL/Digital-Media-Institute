require 'cgi'

class PagesController < ApplicationController
  before_filter :check_admin_user, :except => [:home,:gallery]
  def home
    
  end

  def upload

    storage = Fog::Storage.new({
      :provider => 'AWS',
      :aws_secret_access_key => S3SwfUpload::S3Config.secret_access_key,
      :aws_access_key_id => S3SwfUpload::S3Config.access_key_id
    })
    
    directory = storage.directories.get(S3SwfUpload::S3Config.bucket)
    
    @files = directory.files.all(:prefix => params[:type]).collect do |file|
        if file.public_url
         { :name => CGI::unescape(file.public_url[file.public_url.rindex('/')+1,file.public_url.length]),
           :url =>  file.public_url }
        end
    end.compact

    respond_to do |format|
      format.html { render "upload", :layout => false }
      format.json { render :json => @files.to_json }
    end
  end
end
