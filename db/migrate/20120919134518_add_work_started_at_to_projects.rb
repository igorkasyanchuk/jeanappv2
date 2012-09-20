class AddWorkStartedAtToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :work_started_at, :datetime
  end

  def self.down
    remove_column :projects, :work_started_at
  end
end
