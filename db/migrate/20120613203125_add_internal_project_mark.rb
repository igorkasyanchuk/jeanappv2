class AddInternalProjectMark < ActiveRecord::Migration
  def self.up
    add_column :projects, :internal, :boolean, :default => false
    Project.update_all :internal => false
  end

  def self.down
    remove_column :projects, :internal
  end
end
