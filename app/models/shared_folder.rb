class SharedFolder < ActiveRecord::Base
  attr_accessible :folder_id, :message, :shared_email, :user_id
  
  belongs_to :user
  belongs_to :shared_user, class_name: "User", foreign_key: :shared_user_id
  belongs_to :folder
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :shared_email, format: { with: email_regex }
  validates :folder_id, :shared_email, :user_id, presence: true
  
  before_save :assign_user_id
  
  private
  
    def assign_user_id
      user = User.find_by_email(shared_email)
      self.shared_user_id = user.id if user
    end
end
