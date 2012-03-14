class CreateUserMoneys < ActiveRecord::Migration
  def self.up
    create_table :user_moneys do |t|
      t.integer :user_id
      t.date :date_on
      t.float :amount

      t.timestamps
    end
    add_index :user_moneys, :user_id
    add_index :user_moneys, [:user_id, :date_on]
  end

  def self.down
    remove_index :user_moneys, :user_id
    remove_index :user_moneys, [:user_id, :date_on]
    drop_table :user_moneys
  end
end
