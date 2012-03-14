class AddFilterToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :last_filter, :string, :default => nil
  end

  def self.down
    remove_column :users, :last_filter
  end
end
