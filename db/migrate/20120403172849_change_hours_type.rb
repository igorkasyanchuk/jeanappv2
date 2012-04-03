class ChangeHoursType < ActiveRecord::Migration
  def self.up
    change_column :jobs, :hours, :float
  end

  def self.down
  end
end
