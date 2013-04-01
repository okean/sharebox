class AddAttachmentUploadedFileToDataFiles < ActiveRecord::Migration
  def self.up
    change_table :data_files do |t|
      t.attachment :uploaded_file
    end
  end

  def self.down
    drop_attached_file :data_files, :uploaded_file
  end
end
