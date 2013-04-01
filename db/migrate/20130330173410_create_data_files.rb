class CreateDataFiles < ActiveRecord::Migration
  def self.up
    create_table :data_files do |t|
      t.integer :user_id
      t.timestamps
    end
    
    add_index :data_files, :user_id
  end

  def self.down
    drop_table :data_files
  end
end
