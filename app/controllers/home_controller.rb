class HomeController < ApplicationController
  def index
    if user_signed_in?
      @data_files = current_user.data_files.order('uploaded_file_file_name')
      
      @folders = current_user.folders.order('name')
    end
  end
end
