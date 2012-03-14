class AddMap < ActiveRecord::Migration
  def self.up
    add_column :users, "lat", :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :users, "lng", :decimal, :precision => 15, :scale => 10, :default => 0.0      
    add_column :users, :accuracy, :integer, :default => -1
    add_column :users, :address, :string
    add_column :people, "lat", :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :people, "lng", :decimal, :precision => 15, :scale => 10, :default => 0.0      
    add_column :people, :accuracy, :integer, :default => -1     
  end

  def self.down
    remove_column :users, "lat"
    remove_column :users, "lng"
    remove_column :users, :accuracy
    remove_column :users, :address
    remove_column :people, "lat"
    remove_column :people, "lng"
    remove_column :people, :accuracy
  end
end
