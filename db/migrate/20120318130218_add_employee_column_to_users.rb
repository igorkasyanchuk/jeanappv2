class AddEmployeeColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :employee, :boolean, :default => false
  end

  def self.down
    remove_column :users, :employee
  end
end
