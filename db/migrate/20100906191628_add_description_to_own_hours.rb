class AddDescriptionToOwnHours < ActiveRecord::Migration
  def self.up
    add_column :own_hours, :description, :text
  end

  def self.down
    remove_column :own_hours, :description
  end
end
