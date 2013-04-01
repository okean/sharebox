class HomeController < ApplicationController
  def index
    if user_signed_in?
      @data_files = current_user.data_files.order('uploaded_file_file_name')
    end
  end
end
