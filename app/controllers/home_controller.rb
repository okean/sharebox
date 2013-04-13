class HomeController < ApplicationController
  before_filter :authenticate_user!, only: [:browse, :share]
  
  def index
    if user_signed_in?
      @data_files = current_user.data_files.where("folder_id is NULL").
                                            order('uploaded_file_file_name')
      
      @folders = current_user.folders.roots.order('name')
      
      @being_shared_folders = current_user.shared_folders_by_others
    end
  end
  
  def browse
    @current_folder = current_user.folders.find_by_id(params[:folder_id])
    @is_this_folder_being_shared = false if @current_folder
    
    if @current_folder.nil?
      folder = Folder.find_by_id(params[:folder_id])
      @current_folder ||= folder if current_user.has_share_access?(folder)
      @is_this_folder_being_shared = true if @current_folder
    end
    
    if @current_folder
      @being_shared_folders = []
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
      
      UserMailer.invitation_to_share(@shared_folder).deliver
    end
    
    respond_to do |format|
      format.js {}
    end
  end
end
