class CreateOwnHours < ActiveRecord::Migration
  def self.up
    create_table :own_hours do |t|
      t.integer :project_id
      t.float :hours_count
      t.timestamps
    end
    add_index :own_hours, :project_id
  end

  def self.down
    remove_index :own_hours, :project_id
    drop_table :own_hours
  end
end
