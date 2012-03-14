class AddHoursToProjectStaff < ActiveRecord::Migration
  def self.up
    add_column :project_staffs, :hours_count, :float
    add_column :project_staffs, :created_at, :datetime
  end

  def self.down
    remove_column :project_staffs, :hours_count
    remove_column :project_staffs, :created_at
  end
end
