class DataFilesController < ApplicationController
  before_filter :authenticate_user!
  
  def get
    data_file = current_user.data_files.find_by_id(params[:id])
    if data_file
      send_file data_file.uploaded_file.path,
                type: data_file.uploaded_file_content_type,
                x_sendfile: true
    else
      flash[:error] = "Don't be cheeky! Mind your own files"
      redirect_to data_files_path
    end
  end
  
  def index
    @data_files = current_user.data_files
  end

  def show
    @data_file = current_user.data_files.find(params[:id])
  end

  def new
    @data_file = current_user.data_files.new
    if params[:folder_id]
      @current_folder = current_user.folders.find(params[:folder_id])
      @data_file.folder_id = @current_folder.id
    end
  end

  def create
    @data_file = current_user.data_files.new(params[:data_file])
    if @data_file.save
      flash[:notice] = "Successfully created data file."
      
      if @data_file.folder
        redirect_to browse_path(@data_file.folder)
      else
        redirect_to root_path
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @data_file = current_user.data_files.find(params[:id])
  end

  def update
    @data_file = current_user.data_files.find(params[:id])
    if @data_file.update_attributes(params[:data_file])
      redirect_to @data_file, :notice  => "Successfully updated data file."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @data_file = current_user.data_files.find_by_id(params[:id])

    if @data_file
      current_folder = @data_file.folder
      @data_file.destroy
      flash[:notice] = "Successfully deleted file."
      
      if current_folder
        redirect_to browse_path(current_folder)
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
end
