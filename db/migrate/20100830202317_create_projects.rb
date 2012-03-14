class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :started_on
      t.date :completed_on
      t.float :budget
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
