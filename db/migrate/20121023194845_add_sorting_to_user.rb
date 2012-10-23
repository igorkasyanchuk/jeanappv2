class AddSortingToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :sort_direction, :string
    add_column :users, :sort_field, :string
  end

  def self.down
    remove_column :users, :sort_directions
    remove_column :users, :sort_field
  end
end
