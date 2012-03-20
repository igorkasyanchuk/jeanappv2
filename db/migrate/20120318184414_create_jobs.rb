class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :person_id
      t.integer :project_id
      t.float :rate
      t.integer :hours
      t.text :comment
      t.string :state, :default => 'pending'

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
