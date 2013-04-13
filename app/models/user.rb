class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :data_files, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :shared_folders, dependent: :destroy  
  has_many :being_shared_folders, class_name: "SharedFolder",
                                  foreign_key: "shared_user_id", dependent: :destroy
  has_many :shared_folders_by_others, through: :being_shared_folders, source: :folder
  
  after_create :check_and_assign_shared_folders
  
  def has_share_access?(folder)
    if !folder.nil?
      return true if self.folders.include?(folder)
      return true if self.shared_folders_by_others.include?(folder)
      folder.ancestors.each do |ancestor_folder|
        return true if self.shared_folders_by_others.include?(ancestor_folder)
      end
    end
    return false
  end
  
  private
  
    def check_and_assign_shared_folders
      shared_folders = SharedFolder.find_all_by_shared_email(self.email)
      
      if shared_folders
        shared_folders.each do |shared_folder|
          shared_folder.shared_user_id = self.id
          shared_folder.save
        end
      end
    end
end
