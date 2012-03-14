class AddTaxesToProfile < ActiveRecord::Migration
  def self.up
    add_column :users, :taxes, :float, :default => 0.31
    User.reset_column_information
    User.update_all(:taxes => 0.31)
  end

  def self.down
    remove_column :users, :taxes
  end
end
