class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :person_roles do |t|
      t.string :title
    end
    PersonRole.create(:title => 'Developer')
    PersonRole.create(:title => 'Tester')
    PersonRole.create(:title => 'Designer')
    create_table :people do |t|
      t.integer :person_role_id
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :skype
      t.string :aim
      t.string :jabber
      t.string :odesk_url
      t.string :time_zone
      t.float :hourly_rate
      t.text :description
      t.timestamps
    end
    create_table :project_staffs do |t|
      t.integer :project_id
      t.integer :person_id
      t.float :hourly_rate
      t.text :comment
    end
    add_index :people, :person_role_id
    add_index :project_staffs, :project_id
    add_index :project_staffs, :person_id
  end

  def self.down
    remove_index :people, :person_role_id
    remove_index :projects_staffs, :project_id
    remove_index :projects_staffs, :person_id
    drop_table :person_roles
    drop_table :project_staffs
    drop_table :people
  end
end
