class AddTimeZoneToClient < ActiveRecord::Migration
  def self.up
    add_column :clients, :time_zone, :string
  end

  def self.down
    remove_column :clients, :time_zone
  end
end
