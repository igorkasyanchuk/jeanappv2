class AddPasswordToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :password, :string
  end

  def self.down
    remove_column :invitations, :password
  end
end
