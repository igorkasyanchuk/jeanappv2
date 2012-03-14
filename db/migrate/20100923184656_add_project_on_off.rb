class AddProjectOnOff < ActiveRecord::Migration
  def self.up
    add_column :projects, :turned_on, :boolean, :default => false
  end

  def self.down
    remove_column :projects, :turned_on
  end
end
