class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :project_id
      t.float :hours_count
      t.float :hourly_rate
      t.text :description
      t.timestamps
    end
    add_index :invoices, :project_id
  end

  def self.down
    remove_index :invoices, :project_id
    drop_table :invoices
  end
end
