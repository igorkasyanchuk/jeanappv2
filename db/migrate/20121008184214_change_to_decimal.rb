class ChangeToDecimal < ActiveRecord::Migration
  def self.up
change_column :own_hours, :hours_count, :decimal, :precision => 5, :scale => 2
change_column :invoices, :hours_count, :decimal, :precision => 5, :scale => 2
  end

  def self.down
  end
end
