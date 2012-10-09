class FixJob < ActiveRecord::Migration
  def self.up
change_column :jobs, :hours, :decimal, :precision => 6, :scale => 2 
  end

  def self.down
  end
end
