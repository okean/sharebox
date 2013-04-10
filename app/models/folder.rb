class Folder < ActiveRecord::Base
  acts_as_tree
  
  attr_accessible :name, :parent_id, :user_id
  
  belongs_to :user
  has_many :data_files, dependent: :destroy
  has_many :shared_folders, dependent: :destroy
  
  validates :name, presence: true,
                   length: { maximum: 40 }
  
  def shared?
    !self.shared_folders.empty?
  end
end
