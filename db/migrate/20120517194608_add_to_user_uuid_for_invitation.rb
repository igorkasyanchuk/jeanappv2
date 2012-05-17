class AddToUserUuidForInvitation < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_uuid, :string
  end

  def self.down
    remove_column :users, :invitation_uuid
  end
end
