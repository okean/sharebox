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
  end

  def create
    @data_file = current_user.data_files.new(params[:data_file])
    if @data_file.save
      redirect_to @data_file, :notice => "Successfully created data file."
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
      @data_file.destroy
      redirect_to data_files_url, :notice => "Successfully destroyed data file."
    else
      redirect_to data_files_path
    end
  end
end
