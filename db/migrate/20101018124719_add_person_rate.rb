class AddPersonRate < ActiveRecord::Migration
  def self.up
    add_column :project_staffs, :hourly_rate, :float, :default => 0
    ProjectStaff.reset_column_information
    ProjectStaff.all.each do |p|
      p.hourly_rate = p.person.hourly_rate
      puts p.save
    end
  end

  def self.down
    remove_column :project_staffs, :hourly_rate
  end
end
