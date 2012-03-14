class AddCachedBudgetColumn < ActiveRecord::Migration
  def self.up
    add_column :projects, :cached_budget, :float, :default => 0
    add_column :invoices, :cached_invoice_amount, :float, :default => 0
    [Project, Invoice].each {|k| k.reset_column_information}
    Invoice.all.each do |i|
      i.cached_invoice_amount = i.hourly_rate * i.hours_count
      i.save
    end
    Project.all.each do |p|
      p.recalculate_cached_budget!
    end
  end

  def self.down
    remove_column :projects, :cached_budget
    remove_column :invoices, :cached_invoice_amount
  end
end
