class AddUserType < ActiveRecord::Migration
  def self.up
    add_column :users, :user_type, :string
    User.all.each do |user|
      user.update_attribute :user_type, ((user.projects.count > 0) ? 'owner' : 'employee')
    end
  end

  def self.down
    remove_column :users, :user_type
  end
end
