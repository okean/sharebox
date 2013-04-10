class HomeController < ApplicationController
  before_filter :authenticate_user!, only: [:browse, :share]
  
  def index
    if user_signed_in?
      @data_files = current_user.data_files.where("folder_id is NULL").
                                            order('uploaded_file_file_name')
      
      @folders = current_user.folders.roots.order('name')
    end
  end
  
  def browse
    @current_folder = current_user.folders.find_by_id(params[:folder_id])
    
    if @current_folder
      @folders = @current_folder.children
      @data_files = @current_folder.data_files.order('uploaded_file_file_name')
      render action: "index"
    else
      flash[:error] = "Don't be cheeky! Mind your own folders!"
      redirect_to root_url
    end
  end
  
  def share
    email_addresses = params[:email_addresses].split(',')
    
    email_addresses.each do |email_address|
      @shared_folder = current_user.shared_folders.new
      @shared_folder.folder_id = params[:folder_id]
      @shared_folder.shared_email = email_address
      @shared_folder.message = params[:message]
      @shared_folder.save
    end
    
    respond_to do |format|
      format.js {}
    end
  end
end
