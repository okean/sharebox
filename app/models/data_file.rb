class DataFile < ActiveRecord::Base
  attr_accessible :user_id, :uploaded_file, :folder_id
  
  belongs_to :user
  belongs_to :folder
  
  has_attached_file :uploaded_file,
                    url: "/data_files/get/:id",
                    path: "#{Rails.root}/data_files/:id/:basename.:extension" 
  
  validates_attachment :uploaded_file, presence: true,
                                       size: { in: 0..10.megabytes  }
  
  def file_name
    uploaded_file_file_name
  end
  
  def file_size
    uploaded_file_file_size
  end
end
