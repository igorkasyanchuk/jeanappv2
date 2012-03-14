class MakeCheckedByDefault < ActiveRecord::Migration
  def self.up
    Project.all.each do |p|
      p.turned_on = true
      p.save
    end
    change_column :projects, :turned_on, :boolean, :default => true
  end

  def self.down
  end
end
