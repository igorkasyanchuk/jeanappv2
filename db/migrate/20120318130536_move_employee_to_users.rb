class MoveEmployeeToUsers < ActiveRecord::Migration
  def self.up
    add_column :project_staffs, :new_person_id, :integer
    Person.all.each do |person|
      attributes = person.attributes
      attributes.merge :password => 123456, :employee => true
      user = User.create attributes
      person.project_staffs.update_all :new_person_id => user
    end
    ProjectStaff.all.each do |pf|
      pf.send :write_attribute, :person_id, pf.new_person_id
    end
    remove_column :project_staffs, :new_person_id
    #drop_table :people
  end

  def self.down
    User.where(:employee => true).destroy_all
=begin
    create_table "people" do |t|
      t.integer  "person_role_id"
      t.string   "title"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "email"
      t.string   "skype"
      t.string   "odesk_url"
      t.string   "time_zone"
      t.float    "hourly_rate"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id"
      t.string   "country"
      t.string   "city"
      t.date     "dob"
      t.decimal  "lat",            :precision => 15, :scale => 10, :default => 0.0
      t.decimal  "lng",            :precision => 15, :scale => 10, :default => 0.0
      t.integer  "accuracy",                                       :default => -1
    end

    add_index "people", ["person_role_id"], :name => "index_people_on_person_role_id"
=end   
  end
end
