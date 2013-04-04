class AddFolderIdToDataFiles < ActiveRecord::Migration
  def change
    add_column :data_files, :folder_id, :integer
    add_index :data_files, :folder_id
  end
end
