class AddUserMoneyDescription < ActiveRecord::Migration
  def self.up
    add_column :user_moneys, :description, :text
  end

  def self.down
    remove_column :user_moneys, :description
  end
end
