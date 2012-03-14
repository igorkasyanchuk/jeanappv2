class Fixes < ActiveRecord::Migration
  def self.up
    remove_column :project_staffs, :hourly_rate
    add_column :project_staffs, :description, :text
  end

  def self.down
    add_column :project_staffs, :hourly_rate, :float
    remove_column :project_staffs, :description
  end
end
