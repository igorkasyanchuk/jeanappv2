class CreateUserPersonConnectionTable < ActiveRecord::Migration
  def self.up
    create_table :people_users, :id => false do |t|
      t.integer :user_id
      t.integer :person_id
    end
  end

  def self.down
    drop_table :people_users
  end
end
