class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :project_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.float :rate
      t.string :key
      t.datetime :expires_at

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
