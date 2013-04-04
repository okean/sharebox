class FoldersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @folders = current_user.folders.all
  end

  def show
    @folder = current_user.folders.find(params[:id])
  end

  def new
    @folder = current_user.folders.new
    
    if params[:folder_id]
      @current_folder = current_user.folders.find(params[:folder_id])
      @folder.parent_id = @current_folder.id
    end
  end

  def create
    @folder = current_user.folders.new(params[:folder])
    
    if @folder.save
      flash[:success] = "Successfully created folder."
      
      if @folder.parent
        redirect_to browse_path(@folder.parent)
      else
        redirect_to root_path
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @folder = current_user.folders.find(params[:id])
  end

  def update
    @folder = current_user.folders.find(params[:id])
    if @folder.update_attributes(params[:folder])
      redirect_to @folder, :notice  => "Successfully updated folder."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @folder = current_user.folders.find_by_id(params[:id])
    if @folder
      @folder.destroy
      redirect_to folders_url, :notice => "Successfully destroyed folder."
    else
      redirect_to root_path
    end
  end
end
