class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.integer :project_id
      t.float :amount
      t.text :description
      t.timestamps
    end
    add_index :expenses, :project_id
  end

  def self.down
    remove_index :expenses, :project_id
    drop_table :expenses
  end
end
