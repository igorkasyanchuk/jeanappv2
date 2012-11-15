class AddUuidFieldToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :uuid, :string
    Project.all.each do |project|
      project.uuid = "##{"%04d" % project.id}"
      project.save(:validate => false)
    end
  end

  def self.down
    remove_column :projects, :uuid
  end
end
